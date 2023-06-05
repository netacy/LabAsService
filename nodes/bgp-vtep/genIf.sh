#!/bin/sh
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
for vni in $(seq $first $last)
do
    # Création de l'interface VXLAN
	echo "auto $nic.$vni" >> /etc/network/interface
	echo "iface $nic.$vni inet manual" >> /etc/network/interface
	echo "post-up ip link add link $nic $nic.$vni type vlan proto 802.1ad id $vni" >> /etc/network/interface
	
	echo >> /etc/network/interface
	echo "auto vxlan$vni" >> /etc/network/interface
	echo "iface vxlan$vni inet manual" >> /etc/network/interface
	echo "pre-up ip link add vxlan$vni type vxlan id $vni dstport 0 nolearning" >> /etc/network/interface

	echo "" >> /etc/network/interface
	echo "auto br$vni" >> /etc/network/interface
	echo "iface br$vni inet manual" >> /etc/network/interface
	echo "bridge_ports vxlan$vni $nic.$vni" >> /etc/network/interface
	echo "bridge_stp off"

	echo "#-----------------------------------------------"
# Création du pont associé
done
