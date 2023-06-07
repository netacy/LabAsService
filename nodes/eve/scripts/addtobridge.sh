#!/usr/bin/bash

while true
do
    nics=$(ls /sys/class/net | grep vtep)
    for nic in $nics; do
    brctl addif pnet0 $nic
    done
    sleep 1
done