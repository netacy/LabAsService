#!/bin/bash
version="linux-debian11"

deb11="1k_IDclfdgp41mkH295kWJkbZA8-LWuuN"
FILEID="1Bfu8_0Ew2uQ2Eidne2L2ys5RkXetso4J"
FILENAME="virtioa.qcow2"
mydir=/opt/unetlab/addons/qemu/$version
fich=virtioa.qcow2

hostId=$(cat /root/id)

# Téléchargement si l'image n'existe pas
if [ ! -f "$mydir/$fich" ]; then
        # deb10
        # wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1Bfu8_0Ew2uQ2Eidne2L2ys5RkXetso4J' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1Bfu8_0Ew2uQ2Eidne2L2ys5RkXetso4J" -O $FILENAME && rm -rf /tmp/cookies.txt

        # deb11
        wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1k_IDclfdgp41mkH295kWJkbZA8-LWuuN' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1k_IDclfdgp41mkH295kWJkbZA8-LWuuN" -O $FILENAME && rm -rf /tmp/cookies.txt

        mkdir -p $mydir
        mv $fich  $mydir
fi

echo "Le premier numéro de VLAN (ou VNI) : "
read vni
echo "Nombre d'équipements : "
read nb
echo "Nom de l'image - sans espace (ex: cisco-ap): "
read imageName
echo "Extra VNI (liste séprée par des espaces) :"
read extra
echo "Device offset (pour ip static):"
read deviceOffset
echo "Description = Nom du noeud dans l'interface web - espace tolérés (ex: AP Cisco ): "
read description
echo "Adresse IP du reflecteur de route : "
read rr

nbExtra=$(echo $extra | wc -w)
nbTotal=$(($nbExtra+$nb))


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
sed -i "s/_nb_/$nbTotal/g" $newTemplate
myrand=$RANDOM
sed -i "s/_xxxx_/_$myrand\_/g" $newTemplate



# Création de l'image
newImage=/opt/unetlab/addons/qemu/$imageName-vtep
diskFile=$newImage/virtioa.qcow2
cp -r /opt/unetlab/addons/qemu/$version $newImage

echo $hostId > config
mkisofs -o /opt/unetlab/addons/qemu/$imageName-vtep/cdrom.iso -graft-points config



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
./install.sh eve-vtep-acy \n
echo $vni > /root/conf \n
echo $rr >> /root/conf \n
echo $nbTobal >> /root/conf \n
echo $extra >> /root/conf \n
echo $deviceOffset > /root/deviceOffset

"

echo -e $commands |  chroot /mnt/tmp 

umount /mnt/tmp
#echo "zerofree..."
#zerofree -v /dev/nbd1p1
qemu-nbd -d /dev/nbd1


