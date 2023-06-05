#!/bin/sh

echo "Installation du noeud srv-poe"
apt update && apt install curl sudo snmp apache2
cp -r ./nodes/srv-poe/html/* /var/www/html/
rm /var/www/html/index.html



