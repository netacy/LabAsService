#!/bin/bash

echo "Installation du noeud bgp-vtep"
apt update && apt install -y curl sudo gnupg bridge-utils iptables ebtables
# add GPG key
curl -s https://deb.frrouting.org/frr/keys.asc | sudo apt-key add -

# possible values for FRRVER: frr-6 frr-7 frr-8 frr-stable
# frr-stable will be the latest official stable release
FRRVER="frr-stable"
echo deb https://deb.frrouting.org/frr $(lsb_release -s -c) $FRRVER | sudo tee -a /etc/apt/sources.list.d/frr.list

# update and install FRR
sudo apt update && sudo apt install -y frr frr-pythontools
hostnamectl set-hostname bgp-vtep
echo bgp-vtep >> /etc/hosts


# Renommage des interface réseau en ethX (sinon bug de config qinq !!)
sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"net.ifnames=0 biosdevname=0\"/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Script de démarrage /etc/rc.local
cp ./nodes/bgp-vtep/rc.local.service /etc/systemd/system
cp ./nodes/bgp-vtep/rc.local /etc/
chmod +x /etc/rc.local
systemctl enable rc-local

# Sauvegrade du nom de l'interface uplink et son @MAC
internetIf=$(ip route | grep default | cut -d' ' -f5)
echo $internetIf > /root/tmp
cat /sys/class/net/$internetIf/address >> /root/tmp

# Démarrage automatique de l'interface uplink
isAuto=$(cat /etc/network/interfaces | grep "auto $internetIf" | wc -l)
if [ "$isAuto" = 0 ]; then
    sed -i "s/allow-hotplug $internetIf/auto $internetIf\nallow-hotplug $internetIf/g" /etc/network/interfaces
fi

reboot
