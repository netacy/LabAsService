#!/bin/sh
#

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
  eve)
    ./nodes/eve/install.sh
    ;;
  eve-vtep)
    ./nodes/eve-vtep/install.sh
    ;;
  mk-vtep-eve)
    ./nodes/mk-vtep-eve/install.sh
    ;;
  eve-vtep-acy)
    ./nodes/eve-vtep-acy/install.sh
    ;;
  mk-vtep-eve-acy)
    ./nodes/mk-vtep-eve-acy/install.sh
    ;;

  *)
    echo -n "Parmètre invalide"
    ;;
esac
