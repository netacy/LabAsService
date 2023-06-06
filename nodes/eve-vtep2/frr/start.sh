#!/bin/bash

nic=$(ls /sys/class/net/ | grep eth | tail -n 1)

gw=$(route -n | grep "0.0.0.0" | head -n 1 | cut -d' ' -f10)
ip=$(ip a | grep $nic | tail -n 1 | cut -d' ' -f 6 | cut -d'/' -f1)

cp /etc/frr/frr.ori /etc/frr/frr.conf
sed -i "s/__IP__/$ip/g" /etc/frr/frr.conf
sed -i "s/__GW__/$gw/g" /etc/frr/frr.conf


systemctl start frr
