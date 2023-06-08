# LabAsService
Virtualisez vos lab wifi !!!

## Pour commencer

Ce projet décrit la mise en oeuvre d'une infratructure permettant d'accéder à des point d'accès wifi dans une topologie virtuelle.


## Ressources logicielles :

* [Debian 11](https://www.debian.org) -  VXLAN Tunnel End Point
* [FRRouting](https://frrouting.org) - Plan de contrôle de l'infrastructure VXLAN - BGP EVPN
* [Environnement de virtualisation - EVE-NG](https://www.eve-ng.net/)

## Ressources matérielles :
* [Switch Cisco WS-C3750-48PS-S](https://www.cisco.com/c/en/us/products/switches/catalyst-3750-series-switches/datasheet-listing.html) - 137 euros d'occasion
* En fait n'importe quel swith compatible 802.1ad fera l'affaire (nous utilisons en production un switch DELL EMC Networking N1548P)

* [adaptateur USB3 -> ethernet]() - mettre la référence

* [PC générique] pour la machine bgp-vtep
 
### Infrastructure globale

L'infrastructure globale est la suivante : 

![Topologie Wifi](img/TopoWifi.png)

On va donc se préocuper de tout ce petit monde, soit au minimum :
- 3 VMs
- 1 machine physique : bgp-vtep
- 1 switch : sw-wifi
- 16 AP wifi : 8 Cisco et 8 Ubiquiti

Dans votre hyperviseur préféré vous pouvez provisionner les 3 machines :
- srv-poe en (Debian 11)
- bgp-rr en (Debian 11)
- srv-eve-1 (5.0.1-19-Community) : Le machines EVE peuvent également être excetutées avec VMWare Workstation sur les postes des étudiants. 

Attribuez une adresse IP fixe à chacune des machines et assurez vous qu'elles accèdent bien à Internet.

- La machine bgp-vtep doit être déployée à proximité géographique de sw-wifi. Vous pouvez installer Debian 11 directement dessus ou dans une VM. Si vous avez décidé d'utiliser une VM pour cette machine, assurez vous d'avoir un contrôleur USB3 dans les paramètres de virtualisation, et de connecter l'adaptateur USB/Ethernet dans la VM et non dans l'hôte.

### Installation 1/6 : sw-wifi
Comment évoqué, nous allons déployer 8 points d'accès (AP) Cisco et 8 AP Ubiquiti. Nous proposons la disposition suivante :

![Topologie Wifi](img/InfraSW.png)

Remarques :
- chaque access point (AP) est cloisonné dans un vlan client,
- un point d'accès pourra faire transiter sur son lien filaire des trames 802.1q 
- on retrouvera sur le lien trunk des trames doublement taguées 802.1ad
- les ports impairs sont utilisé pour connecter les APs : On activrea (ou pas) le POE sur ces ports
- les ports pairs ne sont pas connecté et sont réservé pour pouvoir connecter les APs dans des infrascrtutures physiques. Pas de POE sur ces ports.

### Installation 2/6 : bgp-rr
Commencez par configurer l'interface réseau avec une IP fixe en éditant le fichier ``/etc/network/interfaces``

Passez ensuite à l'installation des dépendances :
```
apt update
apt install git
git clone https://www.github.com/netacy/LabAsService
```

```
cd ./LabAsService
./install.sh bgp-rr
```
Et c'est tout ! 
Notez bien l'adresse IP de ce serveur bgp-rr (rr = route reflector), nous en aurons besoin pour la suite
### Installation 3/6 : srv-poe

### Installation 4/6: bgp-vtep
Commencez par configurer l'interface eth0 avec une IP fixe (ou DHCP) en éditant le fichier ``/etc/network/interfaces``

Passez ensuite à l'installation des dépendances :
```
apt update
apt install git
git clone https://www.github.com/netacy/LabAsService
```
```
cd ./LabAsService
./install.sh bgp-vtep
```
Le nom d'hôte et les interfaces réseaux vont être renomées, attendez le redémarrage.
Nous allons personnaliser votre configuration vxlan en fonction de vos besoins :
```
cd ./LabAsService
./install.sh bgp-vtep2
```
Attention, la carte réseau vous connectant à internet a certainement été renommée en eth0 (ou ethX), il convient de rééditer le fichier ``/etc/network/interfaces`` pour corriger ca...

**Vérification 1/2**
 Votre machine doit pouvoir accéder au réseau de votre département/internet
 
 **Vérification 2/2**
La commande ``brctl show``commande doit faire apparaitre les ponts entre les réseaux vxlan et qinq :
```
root@bgp-vtep:~# brctl show
bridge name     bridge id               STP enabled     interfaces
br1001          8000.3aa97a437e71       no              eth1.1001
                                                        vxlan1001
br1002          8000.c20468ef7534       no              eth1.1002
                                                        vxlan1002
...                                                     
```


### Installation 5/6: eve
Votre machine EVE-NG doit être installée et doit pouvoir accéder à Internet.

Commencez par ouvrez une session root sur la machine EVE-NG.

```
apt update
apt install git
git clone https://www.github.com/netacy/LabAsService
```
```
cd ./LabAsService
./install.sh eve
```
Le processus d'installation va :
1. Télécharger un modèle de machine Linux Debian 11 qui sera utilisé dans l'étapge suivante.
2. Installer un réseau NAT "Cloud99" : Ce réseau (192.168.99.0/24 GW=192.168.99.254) donne accès à Internet pour les totologies EVE. 

### Installation 6/6: eve-vtep
Nous allons créer un modèle de noeud qui sera accessible dans l'interface web de EVE-NG. Dans la topologie ce noeud représentera un des équipemets wifi connecté au switch sw-wifi

Toujours depuis une session root dans la machine EVE-NG :
```
cd ./LabAsService
./install.sh mk-vtep-eve
```

On rappelle que le VTEP (VXLAN Tunnel End Point) permettra, depuis une topologie EVE, d'accèder aux vlans du switch sw-wifi.
Admettons que vous avez 8 points d'accès Cisco cloisonés dans les vlans 1001 à 1008 :


echo "Identifiant du 1er vxlan (vni) : "
echo "Nombre de vni : "
echo "Nom de l'image - sans espace (ex: cisco-ap): "
echo "Description = Nom du noeud dans l'interface web - espace tolérés (ex: AP Cisco ): "
echo "Adresse IP du reflecteur de route : "



5 paramètres seront demandés dans le processus d'installation :

1. Le premier numéro de VLAN (ou VNI) : 1001
2. Nombre d'équipements : 8
3. Nom de l'image - sans espace : vtepCisco
4. Description = Nom du noeud dans l'interface web - espace tolérés : Point d'accès Cisco 9100
5. Adresse IP du reflecteur de route : Adresse IP de la machne bgp-rr, (étape 2/6)

Vous pouvez répéter autant de fois que de type d'équipements que vous avez : Si vous avez des AP type Cisco et de Type Ubiquiti, il vous faudra créer 2 VTEP



## Auteurs
Listez le(s) auteur(s) du projet ici !
* **Julien HOARAU** 



