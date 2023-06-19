#!/bin/sh

echo "Installation du noeud srv-poe"
apt update && apt install -y curl sudo snmp apache2 php
cp -r ./nodes/srv-poe/html/* /var/www/html/
rm /var/www/html/index.html



echo "--------------------------------------------"
echo " Configurations "
echo "--------------------------------------------"

