#!/bin/sh
for vni in $(seq 2033 2048)
do
    # Création de l'interface VXLAN
	echo "#+++++++++++++++++++++++++++++++++++++++++++++++"
	echo "auto vxlan$vni"
	echo "iface vxlan$vni inet manual"
        echo "pre-up ip link add vxlan$vni type vxlan id $vni remote 10.108.142.1 dstport 4789 dev eth0"
	echo "post-up bridge fdb append 00:00:00:00:00:00 dev vxlan$vni dst 10.108.142.1"

	vniB=$(($vni-1000))
	echo ""
	echo "auto vxlan$vniB"
	echo "iface vxlan$vniB inet manual"
	echo "pre-up ip link add vxlan$vniB type vxlan id $vniB dstport 0 nolearning"

	echo ""
	echo "auto br$vni"
	echo "iface br$vni inet manual"
	echo "bridge_ports vxlan$vni vxlan$vniB"
	echo "bridge_stp off"

	echo "#-----------------------------------------------"
# Création du pont associé
done
