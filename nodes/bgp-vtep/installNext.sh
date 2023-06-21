#!/bin/bash
cp ./nodes/bgp-vtep/frr.conf.ori /etc/frr/frr.conf

echo
# Le nom de la carte uplink a changé, on détermine son nouveau nom (eth0 ?)
mac=$(tail -n 1 /root/tmp)
oldNic=$(head -n 1 /root/tmp)
for item in $(ls /sys/class/net)
do
    address=$(cat /sys/class/net/$item/address)
    if [ "$mac" = "$address" ]; then
        nic=$item
    fi
done

# MAJ du fichier interfaces
sed -i "s/$oldNic/$nic/g" /etc/network/interfaces
systemctl restart networking


IP=$(ip -4 addr show $nic | awk -F"[/ ]+" '/inet / {print $3}' | head -n 1)
echo "Votre adresse IP=$IP, est-ce correct (o/n) ?"
read ok
if [ "$ok" != "o" ]; then
    echo "Indiquez l'adresse IP de cette hôte :"
    read IP
fi

# Demander l'adresse si elle n'est pas détéctée

echo 
echo "Donnez l'adresse IP de votre reflecteur BGP EVPN :"
read rr
echo "-------------------------------------"
echo

# Personnalisation du fichier de conf FRR
sed -i "s/bgpd=no/bgpd=yes/g" /etc/frr/daemons
sed -i "s/IPADDRESS/$IP/g" /etc/frr/frr.conf
sed -i "s/NIC/$nic/g" /etc/frr/frr.conf
sed -i "s/BGPRR/$rr/g" /etc/frr/frr.conf


chmod +x ./nodes/bgp-vtep/genIf.sh
./nodes/bgp-vtep/genIf.sh $nic

echo "La machine va redémarrer une dernière fois..."
sleep 3
reboot