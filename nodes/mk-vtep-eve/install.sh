#!/bin/bash

echo "Le premier numéro de VLAN (ou VNI) : "
read vni
echo "Nombre d'équipements : "
read nb
echo "Nom de l'image - sans espace (ex: cisco-ap): "
read imageName
echo "Description = Nom du noeud dans l'interface web - espace tolérés (ex: AP Cisco ): "
read description
echo "Adresse IP du reflecteur de route : "
read rr

# Copie de l'image
# cp -r /opt/unetlab/addons/qemu/linux-debian10 /opt/unetlab/addons/qemu/$imageName-vtep


# Création d'un template
newTemplate=/opt/unetlab/html/templates/intel/$imageName.yml
cp /opt/unetlab/html/templates/intel/vtep.yml $newTemplate

eths=""
for id in $(seq 1 $nb)
do
    echo $id
    eths=$eths"- $imageName$id\r\n"
done


sed -i "s/_description_/$description/g" $newTemplate
sed -i "s/_name_/$imageName/g" $newTemplate
sed -i "s/_eth_/$eths/g" $newTemplate
myrand=$RANDOM
sed -i "s/_xxxx_/_$myrand\_/g" $newTemplate

# Création de l'image
newImage=/opt/unetlab/addons/qemu/$imageName-vtep
diskFile=$newImage/virtioa.qcow2
cp -r /opt/unetlab/addons/qemu/linux-debian10 $newImage


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
mkdir -p /mnt/tmp
qemu-nbd -c /dev/nbd1 $diskFile

sleep 2
 
# Montage pour chroot
mount -t auto  /dev/nbd1p1 /mnt/tmp


commands="echo chroot!!! \n
apt update \n
apt install -y git curl sudo gnupg bridge-utils \n
git clone https://github.com/netacy/LabAsService \n
cd ./LabAsService \n
chmod +x ./install.sh \n 
./install.sh eve-vtep \n
echo $vni > /root/conf \n
echo $rr >> /root/conf \n
echo $nb >> /root/conf \n

"

echo -e $commands |  chroot /mnt/tmp 

umount /mnt/tmp
#echo "zerofree..."
#zerofree -v /dev/nbd1p1
qemu-nbd -d /dev/nbd1


