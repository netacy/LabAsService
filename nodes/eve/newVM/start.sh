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
ls -l
EOT

umount /mnt/tmp
echo "zerofree..."
zerofree -v /dev/nbd1p1

qemu-nbd -d /dev/nbd1
#sleep 1
#modprobe -r nbd
