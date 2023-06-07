#!/bin/sh

echo "Personnalisation du noeud eve"
#apt update && apt install curl sudo isc-dhcp-server

# Téléchargement d'une machine Debian11 64bit
# root/Linux
FILEID="1SpUB6ud9hIANG1m_O94_E7MMH3ASAbBH"
FILENAME="virtioa.qcow2"
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1SpUB6ud9hIANG1m_O94_E7MMH3ASAbBH' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1SpUB6ud9hIANG1m_O94_E7MMH3ASAbBH" -O $FILENAME && rm -rf /tmp/cookies.txt

# Création d'une image Linux debian 11
mydir=/opt/unetlab/addons/qemu/linux-debian11
mkdir $mydir
mv virtioa.qcow2  $mydir


# Réglages EVE-NG
# Suppression des templates non disponibles
cp ./nodes/eve/includes/config.php /opt/unetlab/html/includes
cp ./nodes/eve/rc.local /etc
cp ./nodes/eve/rc.local.service /etc/systemd/system
chmod +x /etc/rc.local




cp ./nodes/eve/scripts/addtobridge.sh /opt/unetlab/scripts
chmod +x /opt/unetlab/scripts/addtobridge.sh
cp ./nodes/eve/templates/vtep.yml /opt/unetlab/html/templates/intel

systemctl enable rc-local.service
systemctl start rc-local.service

apt update
apt install -y isc-dhcp-server
cp ./nodes/eve/dhcp/dhcpd.conf /etc/dhcp
echo "INTERFACES=\"pnet99\"" > /etc/default/isc-dhcp-server 
systemctl enable isc-dhcp-server 
systemctl start isc-dhcp-server 

cat ./nodes/eve/interfaces >> /etc/network/interfaces
systemctl restart networking

modprobe nbd

#reboot
