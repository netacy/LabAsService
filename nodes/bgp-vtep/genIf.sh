#!/bin/sh
nicUplink=$1
echo "---------------------------------------------------------------------------------------"
echo " Vous allez déterminer les identifiants de vlan de votre infrastructure"
echo " Soyez prévoyant : Pour déployer 24 AP vous pouvez définir"
echo " 1er identifiant = 1001"
echo " Dernier identifiant = 1024"
echo " Remarques : "
echo "      Ces identifiants sont indépendants des identifiants de votre infrastucture underlay (ie. IUT)"
echo "----------------------------------------------------------------------------------------"

echo "1er identifiant de vlan (ex: 1001):"
read first
echo
echo "Dernier identifiant de vlan (ex: 1024):"
read last
echo
echo "Liste des cartes réseaux détéctées : "
echo "-------------------------------------"
ls /sys/class/net
echo "-------------------------------------"
echo "Quelle carte vous connecte au switch sw-wifi:"
read nic
echo

cp /etc/network/interfaces /etc/network/interfaces.ori

echo $nicUplink >> /root/tmp2
echo $nic > /root/tmp2

# On applique la config IP de l'uplink sur br0
sed -i "s/$nicUplink/br0/g" /etc/network/interfaces
sed -ri "s/(iface br0.+)/\1\nbridge_ports $nicUplink $nic\nbridge_stp on\nup ip link set dev br0 type bridge vlan_filtering 1/g" /etc/network/interfaces

for vni in $(seq $first $last)
do
    # Création de l'interface VXLAN
	echo "#-----------------------------------------------"  >> /etc/network/interfaces
	echo "auto $nic.$vni" >> /etc/network/interfaces
	echo "iface $nic.$vni inet manual" >> /etc/network/interfaces
	echo "pre-up ip link add link $nic $nic.$vni type vlan proto 802.1ad id $vni" >> /etc/network/interfaces
	
	echo "" >> /etc/network/interfaces
	echo "auto vxlan$vni" >> /etc/network/interfaces
	echo "iface vxlan$vni inet manual" >> /etc/network/interfaces
	echo "pre-up ip link add vxlan$vni type vxlan id $vni dstport 0 nolearning" >> /etc/network/interfaces

	echo "" >> /etc/network/interfaces
	echo "auto br$vni" >> /etc/network/interfaces
	echo "iface br$vni inet manual" >> /etc/network/interfaces
	echo "bridge_ports vxlan$vni $nic.$vni" >> /etc/network/interfaces
	echo "bridge_stp off"  >> /etc/network/interfaces

	echo "#-----------------------------------------------"  >> /etc/network/interfaces
done
	# echo "" >> /etc/network/interfaces
	# echo "auto $nic" >> /etc/network/interfaces
	# echo "iface $nic inet static" >> /etc/network/interfaces
	# echo "address 192.168.252.2" >> /etc/network/interfaces
	# echo "netmask 255.255.255.0" >> /etc/network/interfaces
	

