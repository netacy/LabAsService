#!/bin/bash

first=$(cat /root/conf | head -n 1)
rr=$(cat /root/conf | head -n 2 | tail -n 1)
nb=$(cat /root/conf | head -n 3 | tail -n 1)


nics=$(ls /sys/class/net/ | grep en | sort -t s -k 2 --numeric-sort)
#Convert to array
nics=($nics)

#
echo "---------------------------------------------"

last=$(($first+$nb-1))
nicId=0
for vni in $(seq $first $last)
do

	ip link add vxlan$vni type vxlan id $vni dstport 0 nolearning
      	#ip link set up eth$nicId
		ip link set up ${nics[$nicId]}

        brctl addbr br$nicId
        #brctl addif br$nicId eth$nicId vxlan$vni
		brctl addif br$nicId ${nics[$nicId]} vxlan$vni
		
      	ip link set up br$nicId
	ip link set up vxlan$vni

	nicId=$(($nicId+1))
done

# configuration de la dernière carte
# c'est elle qui donne accès au réseau unerlay
hexchars="0123456789ABCDEF"
end=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )
mac=00:60:2F$end

ip link set dev ${nics[$nicId]} address $mac
ip link set up ${nics[$nicId]}

dhclient ${nics[$nicId]}

ip=$(ip a | grep ${nics[$nicId]} | tail -n 1 | cut -d' ' -f 6 | cut -d'/' -f1)
#echo $ip > /tmp/ip
gw=$(ip route | grep default | cut -d' ' -f3)


cp /etc/frr/frr.ori /etc/frr/frr.conf
sed -i "s/__IP__/$ip/g" /etc/frr/frr.conf
sed -i "s/__GW__/$gw/g" /etc/frr/frr.conf
sed -i "s/__RR__/$rr/g" /etc/frr/frr.conf

systemctl start frr
