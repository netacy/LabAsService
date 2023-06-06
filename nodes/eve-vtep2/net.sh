
#!/bin/sh

first=$(cat conf | head -n 1)
nb=$(cat conf | tail -n 1)
echo "---------------------------------------------"

last=$(($first+$nb-1))
nicId=0
for vni in $(seq $first $last)
do

	ip link add vxlan$vni type vxlan id $vni dstport 0 nolearning
      	ip link set up eth$nicId

        brctl addbr br$nicId
        brctl addif br$nicId eth$nicId vxlan$vni
      	ip link set up br$nicId
	ip link set up vxlan$vni

	nicId=$(($nicId+1))
done

# configuration de la dernière carte
# c'est elle qui donne accès au réseau unerlay
hexchars="0123456789ABCDEF"
end=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )
mac=00:60:2F$end

echo $mac
ip link set dev eth$nicId address $mac
ip link set up eth$nicId

dhclient eth$nicId
