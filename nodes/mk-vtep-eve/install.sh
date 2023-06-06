#!/bin/sh

echo "Identifiant du 1er vxlan (vni) : "
read vni
echo "Nombre de vni : "
read nb
echo "Nom de l'image - sans espace (ex: cisco-ap): "
read imageName
echo "Description - avec espace (ex: AP Cisco ): "
read description

# Copie de l'image
cp -r /opt/unetlab/addons/qemu/linux-debian11 /opt/unetlab/addons/qemu/$imageName-vtep


# Création d'un template
newTemplate=/opt/unetlab/html/templates/intel/$imageName-vtep.yml
cp /opt/unetlab/html/templates/intel/vtep.yml $newTemplate

$eths=""
for id in $(seq 1 $nb)
do
    eths=$eths"- $id\r\n"
done

sed -i "s/_description_/$description/g" $newTemplate
sed -i "s/_name_/$imageName/g" $newTemplate
sed -i "s/_eth_/$eth/g" $newTemplate
