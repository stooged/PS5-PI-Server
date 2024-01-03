#!/bin/bash

if [[ $(hostname) == "ps5" ]] ;then
echo "You have run this script already, you cannot run it again"
exit;
fi
sudo apt install dnsmasq nginx -y
sudo sed -i 's/#domain-needed/domain-needed/g' /etc/dnsmasq.conf
sudo sed -i 's/#bogus-priv/bogus-priv/g' /etc/dnsmasq.conf
sudo sed -i 's/#expand-hosts/expand-hosts/g' /etc/dnsmasq.conf
sudo sed -i 's^#conf-file=/etc/dnsmasq.more.conf^conf-file=/etc/dnsmasq.more.conf^g' /etc/dnsmasq.conf
sudo openssl req -subj "/C=US/O=ps5/CN=ps5.local" -x509 -nodes -days 8192 -newkey rsa:2048 -keyout /etc/nginx/sites-available/cert.key -out /etc/nginx/sites-available/cert.crt
sudo sed -i 's/# listen 443 ssl/ listen 443 ssl/g' /etc/nginx/sites-available/default
sudo sed -i 's/# listen \[::\]:443 ssl/ listen \[::\]:443 ssl/g' /etc/nginx/sites-available/default
sudo sed -i 's/server_name _/server_name ps5.local/g' /etc/nginx/sites-available/default
sudo sed -i 's^# SSL configuration^# SSL configuration\r\n	 ssl_certificate /etc/nginx/sites-available/cert.crt;\r\n	 ssl_certificate_key /etc/nginx/sites-available/cert.key;^g' /etc/nginx/sites-available/default
echo '#!/bin/bash
sudo rm /etc/dnsmasq.more.conf
while [ "$(hostname -I)" = "" ]; do
  sleep 1
done
IP=$(hostname -I | cut -f1 -d" ")
echo "address=/playstation.com/127.0.0.1
address=/manuals.playstation.net/$IP
address=/playstation.net/127.0.0.1
address=/playstation.org/127.0.0.1
address=/akadns.net/127.0.0.1
address=/akamai.net/127.0.0.1
address=/akamaiedge.net/127.0.0.1
address=/edgekey.net/127.0.0.1
address=/edgesuite.net/127.0.0.1
address=/llnwd.net/127.0.0.1
address=/scea.com/127.0.0.1
address=/sonyentertainmentnetwork.com/127.0.0.1
address=/ribob01.net/127.0.0.1
address=/cddbp.net/127.0.0.1
address=/nintendo.net/127.0.0.1
address=/ea.com/127.0.0.1" | sudo tee -a /etc/dnsmasq.more.conf
sudo service dnsmasq restart' | sudo tee -a /etc/dstart.sh
sudo cp -r document /var/www/html/
sudo touch /var/www/html/index.html
echo "<html><meta HTTP-EQUIV='REFRESH' content='0; url=/document/index.html'></html>" | sudo tee -a /var/www/html/index.html
sudo sed -i 's^"exit 0"^"exit"^g' /etc/rc.local
sudo sed -i 's^exit 0^sudo bash ./etc/dstart.sh \& \n\nexit 0^g' /etc/rc.local
sudo rm /etc/dnsmasq.more.conf
IP=$(hostname -I | cut -f1 -d' ')
echo "address=/playstation.com/127.0.0.1
address=/manuals.playstation.net/$IP
address=/playstation.net/127.0.0.1
address=/playstation.org/127.0.0.1
address=/akadns.net/127.0.0.1
address=/akamai.net/127.0.0.1
address=/akamaiedge.net/127.0.0.1
address=/edgekey.net/127.0.0.1
address=/edgesuite.net/127.0.0.1
address=/llnwd.net/127.0.0.1
address=/scea.com/127.0.0.1
address=/sonyentertainmentnetwork.com/127.0.0.1
address=/ribob01.net/127.0.0.1
address=/cddbp.net/127.0.0.1
address=/nintendo.net/127.0.0.1
address=/ea.com/127.0.0.1" | sudo tee -a /etc/dnsmasq.more.conf
while true; do
read -p "$(printf '\r\n\r\nDo you want to setup a WIFI access point? (Y|N): ')" wapq
case $wapq in
[Yy]* ) 
sudo apt install dhcpcd5 iptables net-tools -y
echo -e "\r\ninterface wlan1
    static ip_address=10.0.0.1/24
    nohook wpa_supplicant" | sudo tee -a /etc/dhcpcd.conf
echo -e "\r\ninterface=wlan1\r\ndhcp-range=10.0.0.2,10.0.0.20,255.255.255.0,24h" | sudo tee -a /etc/dnsmasq.conf
while true; do
read -p "$(printf '\r\n\r\nDo you want to set a SSID and password for the wifi access point?\r\nif you select no then these defaults will be used\r\n\r\nSSID=PS5_WEB_AP\r\nPASS=password\r\n\r\n(Y|N)?: ')" wapset
case $wapset in
[Yy]* ) 
while true; do
read -p "Enter SSID: " APSSID
case $APSSID in
"" ) 
 echo "Cannot be empty!";;
 * )  
if grep -q '^[0-9a-zA-Z_ -]*$' <<<$APSSID ; then 
if [ ${#APSSID} -le 1 ]  || [ ${#APSSID} -ge 33 ] ; then
echo "SSID must be between 2 and 32 characters long";
else 
break;
fi
else 
echo "SSID must only contain alphanumeric characters"; 
fi
esac
done
while true; do
read -p "Enter password: " APPSWD
case $APPSWD in
"" ) 
 echo "Cannot be empty!";;
 * )  
if [ ${#APPSWD} -le 7 ]  || [ ${#APPSWD} -ge 64 ] ; then
echo "Password must be between 8 and 63 characters long";
else 
break;
fi
esac
done
echo -e 'Using custom settings\r\n\r\nSSID='$APSSID'\r\nPASS='$APPSWD'\r\n\r\n'
mkdir /etc/hostapd/
touch /etc/hostapd/hostapd.conf
echo 'SSID="'$APSSID'"
PASS="'$APPSWD'"' | sudo tee -a /etc/hostapd/hostapd.conf
break;;
[Nn]* ) 
echo -e 'Using default settings\r\n\r\nSSID=PS5_WEB_AP\r\nPASS=password\r\n\r\n'
mkdir /etc/hostapd/
touch /etc/hostapd/hostapd.conf
echo 'SSID="PS5_WEB_AP"
PASS="password"' | sudo tee -a /etc/hostapd/hostapd.conf
break;;
* ) echo "Please answer Y or N";;
esac
done
echo '#!/bin/bash
sleep 10
. /etc/hostapd/hostapd.conf
sudo nmcli connection delete Hotspot
sudo rm /etc/NetworkManager/system-connections/*Hotspot*
sudo systemctl stop dnsmasq.service
sudo systemctl stop dhcpcd.service
sudo sysctl net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -s 10.0.0.0/24 ! -d 10.0.0.0/24 -j MASQUERADE
sudo nmcli dev wifi hotspot ifname wlan1 ssid "$SSID" password "$PASS"
sudo nmcli device modify wlan1 ipv4.method disabled
sudo nmcli device modify wlan1 ipv6.method disabled
sudo nmcli con modify Hotspot connection.autoconnect yes
sudo systemctl start dhcpcd.service
sudo systemctl start dnsmasq.service' | sudo tee -a /etc/startap.sh
sudo sed -i 's^exit 0^sudo sh /etc/startap.sh \& \n\nexit 0^g' /etc/rc.local
echo "Wifi AP installed"
break;;
[Nn]* ) echo "Skipping Wifi AP install"
break;;
* ) echo "Please answer Y or N";;
esac
done
while true; do
read -p "$(printf '\r\n\r\nDo you want to install a FTP server? (Y|N): ')" ftpq
case $ftpq in
[Yy]* ) 
sudo apt-get install vsftpd -y
USR=$(sudo groupmems -g users -l | cut -f1 -d' ')
echo "anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=077
allow_writeable_chroot=YES
chroot_local_user=YES
user_sub_token=$USR
local_root=/var/www/html" | sudo tee -a /etc/vsftpd.conf
sudo chmod 775 /var/www/html/
sudo sed -i 's^exit 0^^g' /etc/rc.local
echo -e "sudo chown -R "$USR":"$USR" /var/www/html/\n\nexit 0" | sudo tee -a /etc/rc.local
echo "FTP Installed"
break;;
[Nn]* ) echo "Skipping FTP install"
break;;
* ) echo "Please answer Y or N";;
esac
done
while true; do
read -p "$(printf '\r\n\r\nDo you want to setup a SAMBA share? (Y|N): ')" smbq
case $smbq in
[Yy]* ) 
sudo apt-get install samba samba-common-bin -y
echo "[www]
path = /var/www/html
writeable=Yes
create mask=0777
read only = no
directory mask=0777
force create mask = 0777
force directory mask = 0777
force user = root
force group = root
public=yes" | sudo tee -a /etc/samba/smb.conf
sudo systemctl unmask smbd
sudo systemctl enable smbd
echo "Samba installed"
break;;
[Nn]* ) echo "Skipping SAMBA install"
break;;
* ) echo "Please answer Y or N";;
esac
done
HSTN=$(hostname | cut -f1 -d' ')
sudo sed -i "s^$HSTN^ps5^g" /etc/hosts
sudo sed -i "s^$HSTN^ps5^g" /etc/hostname
echo "Install complete, Rebooting"
sudo reboot
