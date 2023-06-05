#!/bin/bash

file=$1



#nbNic=$(ls /sys/class/net | grep eth | wc -l)
#lastNicId=$((nbNic-1))

nbNic=$(cat $1 | wc -l)
lastNicId=$nbNic


i=0

echo "auto lo"
echo "iface lo inet loopback"
echo ""

echo "auto eth$lastNicId"
echo "iface eth$lastNicId inet manual"
echo 'pre-up ip link set dev 'eth$lastNicId' address $(/root/mkMac.sh)'
echo ""

while IFS= read -r line
do
	dev=$(echo "$line" | cut -d';' -f1)
	vni=$(echo "$line" | cut -d';' -f2)

	echo "auto $dev"
	echo "iface $dev inet manual"
	echo "pre-up brctl addbr $dev"
	echo "up ip link set $dev up"
	echo "post-down brctl delbr $dev"
	echo ""

	echo "auto eth$i"
	echo "iface eth$i inet manual"
	echo "up ip link set eth$i up"
	echo "up brctl addif $dev eth$i"
	echo "down brctl delif $dev eth$i"
	echo "down ip link set eth$i down"
	echo ""


	echo "auto vxlan$vni"
	echo "iface vxlan$vni inet manual"
	echo "pre-up ip link add vxlan$vni type vxlan id $vni dstport 0 nolearning"
	echo "up ip link set vxlan$vni up"
	echo "up brctl addif $dev vxlan$vni"
	echo ""


	i=$((i+1))
done < "$file"


