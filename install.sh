#!/bin/sh

find . -type f -name *.sh -exec chmod +x {} \;

case $1 in

  bgp-vtep)
    ./nodes/bgp-vtep/install.sh
    ;;
  bgp-vtep2)
    chmod +x ./nodes/bgp-vtep/installNext.sh
    ./nodes/bgp-vtep/installNext.sh
    ;;
  bgp-rr)
    ./nodes/bgp-rr/install.sh
    ;;
  srv-poe)
    ./nodes/srv-poe/install.sh
    ;;


  *)
    echo -n "Parmètre invalide"
    ;;
esac
