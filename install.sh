#!/bin/sh

find . -type f -name *.sh -exec chmod +x {} \;

case $1 in

  bgp-vtep)
    ./nodes/bgp-vtep/install.sh
    ;;

  Romania)
    echo -n "Romanian"
    ;;


  *)
    echo -n "Parmètre invalide"
    ;;
esac
