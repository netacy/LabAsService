#!/bin/sh
echo "Installation de eve-vtep"
  
apt install -y curl sudo
# add GPG key
curl -s https://deb.frrouting.org/frr/keys.asc | sudo apt-key add -

# possible values for FRRVER: frr-6 frr-7 frr-8 frr-stable
# frr-stable will be the latest official stable release
FRRVER="frr-stable"
echo deb https://deb.frrouting.org/frr $(lsb_release -s -c) $FRRVER | sudo tee -a /etc/apt/sources.list.d/frr.list

# update and install FRR
sudo apt update && sudo apt install -y frr frr-pythontools bridge-utils


cp ./nodes/eve-vtep/net.sh /root/
cp ./nodes/eve-vtep/frr/frr.ori /etc/frr/
chmod +x /root/net.sh

cp ./nodes/eve-vtep/rc.local.service /etc/systemd/system
ln -s /etc/systemd/system/rc.local.service  /etc/systemd/system/multi-user.target.wants/rc.local.service
cp ./nodes/eve-vtep/rc.local /etc/
chmod +x /etc/rc.local
systemctl enable rc-local
systemctl disable frr

# activation du process bgp
sed -i "s/bgpd=no/bgpd=yes/g" /etc/frr/daemons
systemctl disable frr

cp ./nodes/eve-vtep/interfaces /etc/network

