#!/usr/bin/bash

while true
do
    nics=$(ls /sys/class/net | grep vtep)
    for nic in $nics; do

        isConnected=$(brctl show | grep $nic | wc -l)
        if [[ "$isConnected" -eq 0 ]]; then
            brctl addif pnet0 $nic
            ip link set up $nic
        fi
        
    done
    sleep 1
done