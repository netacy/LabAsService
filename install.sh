#!/bin/sh

find . -type f -name *.sh -exec chmod +x {} \;

case $1 in

  bgp-vtep)
    ./nodes/bgp-vtep/install.sh
    ;;
  bgp-vtep2)
    ./nodes/bgp-vtep/installNext.sh
    ;;
  Romania)
    echo -n "Romanian"
    ;;


  *)
    echo -n "Parmètre invalide"
    ;;
esac
