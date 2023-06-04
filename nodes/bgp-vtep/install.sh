echo "Installation du noeud bgp-vtep"
apt update && apt install curl sudo gnupg
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

echo "Liste des cartes réseaux détéctées : "
echo "-------------------------------------"
ls /class/sys/net
echo "-------------------------------------"
echo "Quelle carte vous connecte à internet ? :"
read nic
echo 
echo "Donnez l'adresse IP de votre reflecteur BGP EVPN :"
read rr
echo "-------------------------------------"
IP=$(ip -4 addr show $nic | grep -oP "(?<=inet ).*(?=/)")
echo "Votre adresse IP" $IP
sed -i "s/IPADDRESS/$IP/g" /etc/frr/frr.conf
sed -i "s/NIC/$nic/g" /etc/frr/frr.conf
sed -i "s/BGPRR/$rr/g" /etc/frr/frr.conf



cp ./nodes/bgp-vtep/start.sh /etc/frr

reboot
