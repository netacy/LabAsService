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
* [adaptateur USB3 -> ethernet]() - mettre la référence
* [PC générique]

### Pré-requis

Il convient tout d'abord câbler l'infrastrucure globale :

- Les points d'accès wifi
- le serveur bgp-vtep 

![Topologie Wifi](img/TopoWifi.png)

Dans votre datacenter préféré vous pouvez provisionner les machines :
- srv-poe (Debian 11)
- bgp-rr (Debian 11)

Installez également Debian 11 sur la machine bgp-vtep

### Installation 1/6 : sw-wifi
### Installation 2/6 : bgp-rr
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
Attention, la carte réseau vous connectant à internet a certainement été renommée en eth0, il convient de rééditer le fichier ``/etc/network/interfaces`` pour corriger ca...

**Vérification**
 1/2 - Votre machine doit pouvoir accéder au réseau de votre département/internet
 2/2 - ```brctl show```

Cette dernière commande doit faire apparaitre les interfaces 
``
root@bgp-vtep:~# brctl show
bridge name     bridge id               STP enabled     interfaces
br1001          8000.3aa97a437e71       no              eth1.1001
                                                        vxlan1001
br1002          8000.c20468ef7534       no              eth1.1002
                                                        vxlan1002``


### Installation 5/6: eve

### Installation 6/6: eve-vtep

## Auteurs
Listez le(s) auteur(s) du projet ici !
* **Julien HOARAU** _alias_ [netacy](https://github.com/netacy)



