#!/bin/bash
version="linux-debian11"

deb11="1k_IDclfdgp41mkH295kWJkbZA8-LWuuN"
FILEID="1Bfu8_0Ew2uQ2Eidne2L2ys5RkXetso4J"
FILENAME="virtioa.qcow2"
imagesPath=/opt/unetlab/addons/qemu
mydir=$imagesPath/$version
fich=virtioa.qcow2



echo "Il est nécessaire de disposer en local d'une image générique de Linux Debian pour la suite des opérations."
echo "Souhaitez vous en télécharger une ou utiliser une image existante sur votre machine EVE ?"
echo "1 - Télécharger l'image"
echo "2 - Utiliser une image existante"
echo "Votre choix ([1]|2) : "
read choix

echo "Choisissez une VM à utiliser comme modèle pour générer le VTEP :"
if [ "$choix" = "2" ];
then
        images=$(ls $imagesPath)
        cpt=1
        for image in $images
        do
                echo $cpt - $image
                cpt=$(($cpt+1))
        done
        max=$(($cpt-1))
        echo "Votre choix (1-$max):"
        read choix
        choix=$(($choix-1))
        images=($images)
        echo "Choix effectué : ${images[$choix]}"

        version=${images[$choix]}
        vmPath="$imagesPath/${images[$choix]}"
        diskPath=$(ls $vmPath/*.qcow2 | head -n 1)
        
        if [ ! -f "$diskPath" ] ;
        then
        
                echo "Impossible d'aller plus loin, relancez le script et modifiez vos choix !"
                exit
        fi
        
else
        # Téléchargement si l'image n'existe pas
        if [ ! -f "$mydir/$fich" ]; then
                # deb10
                # wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1Bfu8_0Ew2uQ2Eidne2L2ys5RkXetso4J' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1Bfu8_0Ew2uQ2Eidne2L2ys5RkXetso4J" -O $FILENAME && rm -rf /tmp/cookies.txt

                # deb11
                wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1k_IDclfdgp41mkH295kWJkbZA8-LWuuN' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1k_IDclfdgp41mkH295kWJkbZA8-LWuuN" -O $FILENAME && rm -rf /tmp/cookies.txt

                mkdir -p $mydir
                mv $fich  $mydir
        fi
fi



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
sed -i "s/_nb_/$nb/g" $newTemplate
myrand=$RANDOM
sed -i "s/_xxxx_/_$myrand\_/g" $newTemplate

# Creation de l'image
newImage=/opt/unetlab/addons/qemu/$imageName-vtep
diskFile=$(ls $newImage/*.qcow2 | head -n 1)
echo "Disque = $diskFile"
if [ ! -f "$diskFile" ];
then
        echo "Impossible de monter l'image disk $diskFile"
        exit
fi

cp -r /opt/unetlab/addons/qemu/$version $newImage


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


