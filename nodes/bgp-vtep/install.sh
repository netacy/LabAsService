echo "Installation du noeud bgp-vtep"
apt update && apt install curl sudo gnupg bridge-utils
# add GPG key
curl -s https://deb.frrouting.org/frr/keys.asc | sudo apt-key add -

# possible values for FRRVER: frr-6 frr-7 frr-8 frr-stable
# frr-stable will be the latest official stable release
FRRVER="frr-stable"
echo deb https://deb.frrouting.org/frr $(lsb_release -s -c) $FRRVER | sudo tee -a /etc/apt/sources.list.d/frr.list

# update and install FRR
sudo apt update && sudo apt install frr frr-pythontools
hostnamectl set-hostname bgp-vtep

cp ./nodes/bgp-vtep/frr.conf.ori /etc/frr
cp /etc/frr/frr.conf.ori /etc/frr/frr.conf

echo
echo "Liste des cartes réseaux détéctées : "
echo "-------------------------------------"
ls /sys/class/net
echo "-------------------------------------"
echo "Quelle carte vous connecte à internet ? :"
read nic
IP=$(ip -4 addr show $nic | grep -oP "(?<=inet ).*(?=/)")
echo "Votre adresse IP" $IP
echo 
echo "Donnez l'adresse IP de votre reflecteur BGP EVPN :"
read rr
echo "-------------------------------------"
echo

sed -i "s/IPADDRESS/$IP/g" /etc/frr/frr.conf
sed -i "s/NIC/$nic/g" /etc/frr/frr.conf
sed -i "s/BGPRR/$rr/g" /etc/frr/frr.conf
sed -i "s/bgpd=no/bgpd=yes/g" /etc/frr/daemons

systemctl stop frr
systemctl start frr

chmod +x ./nodes/bgp-vtep/install.sh
./nodes/bgp-vtep/install.sh

#reboot
