#!/bin/sh

echo "Personnalisation du noeud eve"
#apt update && apt install curl sudo isc-dhcp-server

FILEID="1SpUB6ud9hIANG1m_O94_E7MMH3ASAbBH"
FILENAME="virtioa.qcow2"

wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1SpUB6ud9hIANG1m_O94_E7MMH3ASAbBH' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1SpUB6ud9hIANG1m_O94_E7MMH3ASAbBH" -O $FILENAME && rm -rf /tmp/cookies.txt

mydir=/opt/unetlab/addons/qemu/linux-debian11
mkdir $mydir
mv virtioa.qcow2  $mydir

cp ./nodes/eve/includes/config.php /opt/unetlab/html/includes


#reboot
