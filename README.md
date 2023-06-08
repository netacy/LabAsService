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

### Trafic à autoriser 
- srv-poe <-> sw-wifi  = UDP port 161 (SNMP)
- bgp-vtep <-> srv-eve = UDP port 4789 (flux data vxlan)
- bgp-vtep <-> bgp-rr  = TCP 179 (route BGP)

### Installation 1/6 : sw-wifi
Comment évoqué, nous allons déployer 8 points d'accès (AP) Cisco et 8 AP Ubiquiti. Nous proposons la disposition suivante :

![Topologie Wifi](img/InfraSW.png)

Remarques :
- chaque access point (AP) est cloisonné dans un vlan client (ici vlans 1000 à 1015)
- un point d'accès pourra faire transiter sur son lien filaire des trames 802.1q 
- on retrouvera sur le lien trunk des trames doublement taguées 802.1ad
- les ports impairs sont utilisé pour connecter les APs : On activrea (ou pas) le POE sur ces ports
- les ports pairs ne sont pas connecté et sont réservé pour pouvoir connecter les APs dans des infrascrtutures physiques. Pas de POE sur ces ports.
 
Un exemple de configuration est disponible ici (TODO). Il conviendra d'adapter l'adresse IP de management et les identifiants de connexion SNMP et les personnalisant un peu ces valeurs...

### Installation 2/6 : srv-poe
Si ce n'est déjà fait, configurez l'interface réseau avec une IP fixe en éditant le fichier ``/etc/network/interfaces``

Passez ensuite à l'installation des dépendances :
```
apt update
apt install git
git clone https://www.github.com/netacy/LabAsService
```

```
cd ./LabAsService
./install.sh srv-poe
```
Le service web déployé permet de piloter l'état des port POE (les ports impairs) de sw-wifi.
Vous pourrez vous inspirer des pages html/php pour adapter le dashboard en fonction des équipements que vous déployez rééllement.

### Installation 3/6 : bgp-rr
Si ce n'est déjà fait, configurez l'interface réseau avec une IP fixe en éditant le fichier ``/etc/network/interfaces``

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

Notez bien l'adresse IP de ce serveur bgp-rr (rr = route reflector), nous en aurons besoin pour la suite.
Dans notre cas @IP RR = 10.108.143.51

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
Le nom d'hôte et les interfaces réseaux vont être renommées, attendez le redémarrage.
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
Votre machine EVE-NG doit être installée et doit pouvoir accéder à Internet, il n'est pas indispensable qu'elle possède un adresse IP fixe.

Commencez par ouvrir une session root sur la machine EVE-NG.

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
1. Télécharger un modèle de machine Linux Debian 11 (nom=linux-debian11 login/passwd=root/Linux), elle sera utilisée dans l'étapge suivante (6/6).
2. Installer un réseau NAT "Cloud99" : Ce réseau (192.168.99.0/24 GW=192.168.99.254) donne accès à Internet pour les totologies EVE. 
3. Compléter la configuration de EVE-NG pour pouvoir disposer de nouveaux modèles de noeuds 

**Remarque importante**
- Si cette machine EVE est exécutée dans un hyperviseur ESXi il convient certainement d'acctiver le mode promiscuité sur la carte réseau de la VM. En effet, le réseau de l'hypervieur risque de ne pas apprécier des trames sortantes avec des adresses MAC sources non connues.

### Installation 6/6: eve-vtep
Nous allons créer un modèle de noeud qui sera accessible dans l'interface web de EVE-NG. Dans la topologie ce noeud représentera un des équipemets wifi connecté au switch sw-wifi.

Toujours depuis une session root dans la machine EVE-NG :
```
cd ./LabAsService
./install.sh mk-vtep-eve
```

On rappelle que le VTEP (VXLAN Tunnel End Point) permettra, depuis une topologie EVE, d'accèder aux vlans du switch sw-wifi.

5 paramètres seront demandés dans le processus d'installation :

1. Le premier numéro de VLAN (ou VNI) : 1000
2. Nombre d'équipements : 8
3. Nom de l'image - sans espace : ubiquitiAP
4. Description = Nom du noeud dans l'interface web - espace tolérés : Point d'accès Ubiquiti
5. Adresse IP du reflecteur de route : 10.108.143.51, (étape 2/6)

Cette étape est à répéter pour ajouter un deuxième modèle de noeud type Cisco :

1. Le premier numéro de VLAN (ou VNI) : 1008
2. Nombre d'équipements : 8
3. Nom de l'image - sans espace : ciscoAP
4. Description = Nom du noeud dans l'interface web - espace tolérés : Point d'accès Cisco
5. Adresse IP du reflecteur de route : 10.108.143.51, (étape 2/6)

- Il conviendra de modifier l'icône des templates nouvellement crées ``vtepCisco`` et ``vtepUbiquiti`` en éditant les fichiers ``/opt/unetlab/html/templates/intel/vtepCisco.yml`` et ``/opt/unetlab/html/templates/intel/vtepUbiquiti.yml`` les imgages utilisées sont situées dans ``/opt/unetlab/html/templates/images/icons``

**Vérification**

Dans un lab EVE-NG ajouter un noeud de type "Point d'accès Cisco" non connecté.
Une fois démarré (root/Linux) vous devrier pouvoir envoyer des ping vers Internet ou des cibles de votre infrastructure. 


## Auteurs
Listez le(s) auteur(s) du projet ici !
* **Julien HOARAU** 



