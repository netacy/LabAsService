#!/bin/sh

echo "Personnalisation du noeud eve"
#apt update && apt install curl sudo isc-dhcp-server

# Téléchargement d'une machine Debian11 64bit
# root/Linux
# FILEID="1Bfu8_0Ew2uQ2Eidne2L2ys5RkXetso4J"
# FILENAME="virtioa.qcow2"
# wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1Bfu8_0Ew2uQ2Eidne2L2ys5RkXetso4J' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1Bfu8_0Ew2uQ2Eidne2L2ys5RkXetso4J" -O $FILENAME && rm -rf /tmp/cookies.txt

# # Création d'une image Linux debian 11
# mydir=/opt/unetlab/addons/qemu/linux-debian10
# mkdir -p $mydir
# mv virtioa.qcow2  $mydir


# Réglages EVE-NG
# Suppression des templates non disponibles
cp ./nodes/eve/includes/config.php /opt/unetlab/html/includes
cp ./nodes/eve/rc.local /etc
cp ./nodes/eve/rc.local.service /etc/systemd/system
chmod +x /etc/rc.local




cp ./nodes/eve/scripts/addtobridge.sh /opt/unetlab/scripts
chmod +x /opt/unetlab/scripts/addtobridge.sh
cp ./nodes/eve/templates/vtep.yml /opt/unetlab/html/templates/intel
cp ./nodes/eve/images/* /opt/unetlab/html/images/icons/

systemctl enable rc-local.service
systemctl start rc-local.service

apt install -y isc-dhcp-server

cp ./nodes/eve/dhcp/dhcpd.conf /etc/dhcp
echo "INTERFACES=\"pnet99\"" > /etc/default/isc-dhcp-server 
systemctl enable isc-dhcp-server 
systemctl start isc-dhcp-server 

# Permet l'ouverture simultanée de plusieurs sessions sur une VM
echo "mysql-default-max-connections-per-user: 10" >> /etc/guacamole/guacamole.properties

# Ouverture de session multiples sur eve-ng
sed -i "s/genUuid/genUuid2/g" /opt/unetlab/html/includes/__lab.php
sed -i "s/genUuid/genUuid2/g" /opt/unetlab/html/includes/functions.php

sed -i "s/?>//g" /opt/unetlab/html/includes/functions.php

echo "function genUuid() {
	return \"838bdd60-38b6-4595-b2f4-122bef272ce0\";
}

?>
" >> /opt/unetlab/html/includes/functions.php

cat ./nodes/eve/interfaces >> /etc/network/interfaces
systemctl restart networking

modprobe nbd

#reboot
