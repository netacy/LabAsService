#!/bin/bash

################################################################
# $1 -> emplacement de la VM à cloner 
# $2 -> nom de la nouvelle VM (dans $base)
#
# Créer une copie et monte le disque vmdk en chroot
#    Effectuer les changement nécessaire
#    Saisir exit et appeler ensuite ./finish.sh
################################################################



# le périphérique nbd doit être libéré au préalable
echo "Check /dev/nbd1"
nbd1=$(($(lsblk | grep nbd1 | head -n 1 | wc -l)))
if [ "$nbd1" -eq 0 ]; then
        echo "[ok]"
else
        echo "[nok] : Le périphérique /dev/nbd1 n'est pas libre"
        exit
fi

################################################################
#
################################################################

modprobe nbd
mkdir /mnt/tmp

diskFile=/opt/unetlab/addons/qemu/uap/virtioa.qcow2
qemu-nbd -c /dev/nbd1 $diskFile

sleep 2

# Montage pour chroot
mount -t auto  /dev/nbd1p1 /mnt/tmp

# Script à modifier ici
chroot /mnt/tmp  <<"EOT"
echo "chroot!!!"
apt update && apt install curl sudo gnupg bridge-utils
# add GPG key
curl -s https://deb.frrouting.org/frr/keys.asc | sudo apt-key add -

# possible values for FRRVER: frr-6 frr-7 frr-8 frr-stable
# frr-stable will be the latest official stable release
FRRVER="frr-stable"
echo deb https://deb.frrouting.org/frr $(lsb_release -s -c) $FRRVER | sudo tee -a /etc/apt/sources.list.d/frr.list

# update and install FRR
sudo apt update && sudo apt install frr frr-pythontools
hostnamectl set-hostname eve-vtep

# activation du process bgp
sed -i "s/bgpd=no/bgpd=yes/g" /etc/frr/daemons
EOT

umount /mnt/tmp
echo "zerofree..."
zerofree -v /dev/nbd1p1

qemu-nbd -d /dev/nbd1
#sleep 1
#modprobe -r nbd
