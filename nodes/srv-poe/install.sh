#!/bin/sh

echo "Installation du noeud srv-poe"
apt update && apt install curl sudo snmp apache2
cp -r ./nodes/srv-poe/html/* /var/www/html/
rm /var/www/html/index.html



echo "--------------------------------------------"
echo " Configurations "
echo "--------------------------------------------"

echo

echo " Adresse IP d'administration du switch :"
read IP

echo " Utilisateur snmp :"
read USER

echo " Mot de passe snmp :"
read PASSWORD

echo " Réseau autorisé pour les clients web (ex: 10.1.2)"
read NETALLOWED

echo 

sed -i "s/_IP_/$IP/g" /var/www/html/configMonSW.php
sed -i "s/_USER_/$USER/g" /var/www/html/configMonSW.php
sed -i "s/_PASSWORD_/$PASSWORD/g" /var/www/html/configMonSW.php
sed -i "s/_NETALLOWED_/$NETALLOWED/g" /var/www/html/configMonSW.php

