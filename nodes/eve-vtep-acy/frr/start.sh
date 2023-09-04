#!/bin/bash

nic=$(ls -v /sys/class/net/ | grep ens | tail -n 1)

gw=$(ip route | grep default | cut -d' ' -f3)
ip=$(ip route | tail -n 1 | cut -d' ' -f9)
rr=$(cat /root/conf | head -n 2 | tail -n 1)

cp /etc/frr/frr.ori /etc/frr/frr.conf
sed -i "s/__IP__/$ip/g" /etc/frr/frr.conf
sed -i "s/__GW__/$gw/g" /etc/frr/frr.conf
sed -i "s/__RR__/$rr/g" /etc/frr/frr.conf


systemctl start frr
