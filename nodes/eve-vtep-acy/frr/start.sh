#!/bin/bash

nic=$(ls -v /sys/class/net/ | grep ens | tail -n 1)

gw=$(ip route | grep default | cut -d' ' -f3)
ip=$(ip a | grep $nic | tail -n 1 | cut -d' ' -f 6 | cut -d'/' -f1)

cp /etc/frr/frr.ori /etc/frr/frr.conf
sed -i "s/__IP__/$ip/g" /etc/frr/frr.conf
sed -i "s/__GW__/$gw/g" /etc/frr/frr.conf


systemctl start frr
