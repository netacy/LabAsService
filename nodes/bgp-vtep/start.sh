#!/bin/sh

IP=$(ip -4 addr show pnet0 | grep -oP "(?<=inet ).*(?=/)")
echo $IP
cp /etc/frr/frr.conf.ori /etc/frr/frr.conf
sed -i "s/IPADDRESS/$IP/g" /etc/frr/frr.conf
systemctl stop frr
systemctl start frr
