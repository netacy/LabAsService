#!/bin/sh
echo "Installation de eve-vtep"
  
# add GPG key
curl -s https://deb.frrouting.org/frr/keys.asc | sudo apt-key add -

# possible values for FRRVER: frr-6 frr-7 frr-8 frr-stable
# frr-stable will be the latest official stable release
FRRVER="frr-stable"
echo deb https://deb.frrouting.org/frr $(lsb_release -s -c) $FRRVER | sudo tee -a /etc/apt/sources.list.d/frr.list

# update and install FRR
sudo apt update && sudo apt install -y frr frr-pythontools

# Renommage des interfaces
sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"net.ifnames=0 biosdevname=0\"/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

cp ./nodes/eve-vtep/net.sh /root/
cp ./nodes/eve-vtep/frr/frr.conf /etc/frr/
chmod +x /root/net.sh

# activation du process bgp
sed -i "s/bgpd=no/bgpd=yes/g" /etc/frr/daemons

IP="monIP"
RR="monRR"

sed -i "s/_IP_/$IP/g" /etc/frr/frr.conf
sed -i "s/_IP_/$RR/g" /etc/frr/frr.conf

