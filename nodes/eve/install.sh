#!/bin/sh

echo "Personnalisation du noeud eve"
apt update && apt install curl sudo isc-dhcp-server

#cp ./nodes/bgp-vtep/rc.local.service /etc/systemd/system


#reboot
