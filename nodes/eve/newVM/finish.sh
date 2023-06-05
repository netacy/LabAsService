#!/bin/bash

umount /mnt/tmp
echo "zerofree..."
zerofree -v /dev/nbd1p1

qemu-nbd -d /dev/nbd1
sleep 1
modprobe -r nbd

