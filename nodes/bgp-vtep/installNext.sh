#!/bin/bash
cp ./nodes/bgp-vtep/frr.conf.ori /etc/frr
cp /etc/frr/frr.conf.ori /etc/frr/frr.conf

echo
echo "Liste des cartes réseaux détéctées : "
echo "-------------------------------------"
ls /sys/class/net
echo "-------------------------------------"

# nouveau nom de la carte qui donne accès à internet
mac=$(tail -n 1 /root/tmp)
for item in $(ls /sys/class/net)
do
    address=$(cat /sys/class/net/$item/address)
    if [ "$mac" = "$address" ]; then
        echo $item
    fi
done

echo "Quelle carte vous connecte à internet ? :"
read nic

IP=$(ip -4 addr show $nic | grep -oP "(?<=inet ).*(?=/)")
echo "Votre adresse IP" $IP
echo 
echo "Donnez l'adresse IP de votre reflecteur BGP EVPN :"
read rr
echo "-------------------------------------"
echo

sed -i "s/bgpd=no/bgpd=yes/g" /etc/frr/daemons
sed -i "s/IPADDRESS/$IP/g" /etc/frr/frr.conf
sed -i "s/NIC/$nic/g" /etc/frr/frr.conf
sed -i "s/BGPRR/$rr/g" /etc/frr/frr.conf



systemctl stop frr
systemctl start frr

chmod +x ./nodes/bgp-vtep/genIf.sh
./nodes/bgp-vtep/genIf.sh
