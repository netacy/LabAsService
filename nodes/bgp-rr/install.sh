#!/bin/sh

echo "Installation du noeud bgp-vtep"
apt update && apt install curl sudo gnupg bridge-utils
# add GPG key
curl -s https://deb.frrouting.org/frr/keys.asc | sudo apt-key add -

# possible values for FRRVER: frr-6 frr-7 frr-8 frr-stable
# frr-stable will be the latest official stable release
FRRVER="frr-stable"
echo deb https://deb.frrouting.org/frr $(lsb_release -s -c) $FRRVER | sudo tee -a /etc/apt/sources.list.d/frr.list

# update and install FRR
sudo apt update && sudo apt install frr frr-pythontools
hostnamectl set-hostname bgp-rr

# activation du process bgp
sed -i "s/bgpd=no/bgpd=yes/g" /etc/frr/daemons

cp ./nodes/bgp-rr/frr.conf.ori /etc/frr
cp /etc/frr/frr.conf.ori /etc/frr/frr.conf


# NIC 
# NETID 
# CIDR

MYIP=$(ip a | grep dynamic | head -n 1| cut -d' ' -f6 | cut -d'/' -f1)
echo "Adresse IP = $MYIP"
sed -i "s/MYIP/$MYIP/g" /etc/frr/frr.conf

systemctl restart frr

#reboot
