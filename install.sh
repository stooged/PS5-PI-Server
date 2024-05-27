#!/bin/bash

PITYP=$(tr -d '\0' </proc/device-tree/model) 
echo -e '\033[32mInstalling PS5 PI Server on\033[33m '$PITYP'\033[0m'
sudo apt install dnsmasq nginx -y
echo 'bogus-priv
expand-hosts
domain-needed
conf-file=/etc/dnsmasq.more.conf' | sudo tee /etc/dnsmasq.conf
sudo openssl req -subj "/C=US/O=ps5/CN=ps5.local" -x509 -nodes -days 8192 -newkey rsa:2048 -keyout /etc/nginx/sites-available/cert.key -out /etc/nginx/sites-available/cert.crt
echo 'server {
	listen 80 default_server;
	listen [::]:80 default_server;
	ssl_certificate /etc/nginx/sites-available/cert.crt;
	ssl_certificate_key /etc/nginx/sites-available/cert.key;
	listen 443 ssl default_server;
	listen [::]:443 ssl default_server;
	root /var/www/html;
	index index.html index.htm index.nginx-debian.html;
	server_name ps5.local;
	location / {
		try_files $uri $uri/ =404;
	}
}' | sudo tee /etc/nginx/sites-enabled/default
sudo cp -r document /var/www/html/
sudo touch /var/www/html/index.html
echo "<html><meta HTTP-EQUIV='REFRESH' content='0; url=/document/index.html'></html>" | sudo tee /var/www/html/index.html
echo "address=/playstation.com/127.0.0.1
address=/manuals.playstation.net/10.0.0.1
address=/playstation.net/127.0.0.1
address=/playstation.org/127.0.0.1
address=/akadns.net/127.0.0.1
address=/akamai.net/127.0.0.1
address=/akamaiedge.net/127.0.0.1
address=/edgekey.net/127.0.0.1
address=/edgesuite.net/127.0.0.1
address=/llnwd.net/127.0.0.1
address=/scea.com/127.0.0.1
address=/sie-rd.com/127.0.0.1
address=/llnwi.net/127.0.0.1
address=/sonyentertainmentnetwork.com/127.0.0.1
address=/ribob01.net/127.0.0.1
address=/cddbp.net/127.0.0.1
address=/nintendo.net/127.0.0.1
address=/ea.com/127.0.0.1" | sudo tee /etc/dnsmasq.more.conf
while true; do
read -p "$(printf '\r\n\r\n\033[36mDo you want to setup a WIFI access point? (Y|N): \033[0m')" wapq
case $wapq in
[Yy]* ) 
sudo apt install hostapd dhcpcd iptables net-tools -y
echo -e "duid
persistent
vendorclassid
option domain_name_servers, domain_name, domain_search
option classless_static_routes
option interface_mtu
option host_name
option rapid_commit
require dhcp_server_identifier
slaac private

interface wap0
    static ip_address=10.0.0.1/24
    nohook wpa_supplicant" | sudo tee /etc/dhcpcd.conf	
echo -e "\r\ninterface=wap0\r\ndhcp-range=10.0.0.2,10.0.0.2,255.255.255.0,24h\r\ninterface="$WLN"\r\ninterface=end0\r\ninterface=eth0" | sudo tee -a /etc/dnsmasq.conf
while true; do
read -p "$(printf '\r\n\r\n\033[36mDo you want to set a SSID and password for the wifi access point?\r\nif you select no then these defaults will be used\r\n\r\nSSID=\033[33mPS5_WEB_AP\r\n\033[36mPASS=\033[33mpassword\r\n\r\n\033[36m(Y|N)?: \033[0m')" wapset
case $wapset in
[Yy]* ) 
while true; do
read -p  "$(printf '\033[33mEnter SSID: \033[0m')" APSSID
case $APSSID in
"" ) 
 echo -e '\033[31mCannot be empty!\033[0m';;
 * )  
if grep -q '^[0-9a-zA-Z_ -]*$' <<<$APSSID ; then 
if [ ${#APSSID} -le 1 ]  || [ ${#APSSID} -ge 33 ] ; then
echo -e '\033[31mSSID must be between 2 and 32 characters long\033[0m';
else 
break;
fi
else 
echo -e '\033[31mSSID must only contain alphanumeric characters\033[0m';
fi
esac
done
while true; do
read -p "$(printf '\033[33mEnter password: \033[0m')" APPSWD
case $APPSWD in
"" ) 
 echo -e '\033[31mCannot be empty!\033[0m';;
 * )  
if [ ${#APPSWD} -le 7 ]  || [ ${#APPSWD} -ge 64 ] ; then
echo -e '\033[31mPassword must be between 8 and 63 characters long\033[0m';
else 
break;
fi
esac
done
echo -e '\033[36mUsing custom settings\r\n\r\nSSID=\033[33m'$APSSID'\r\n\033[36mPASS=\033[33m'$APPSWD'\r\n\r\n\033[0m'
break;;
[Nn]* ) 
echo -e '\033[36mUsing default settings\r\n\r\nSSID=\033[33mPS5_WEB_AP\r\n\033[36mPASS=\033[33mpassword\r\n\r\n\033[0m'
 APSSID="PS5_WEB_AP"
 APPSWD="password"
break;;
* ) echo -e '\033[31mPlease answer Y or N\033[0m';;
esac
done
echo "country_code=US
interface=wap0
ssid="$APSSID"
channel=7
auth_algs=1
wpa=2
wpa_passphrase="$APPSWD"
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
rsn_pairwise=CCMP" | sudo tee /etc/hostapd/hostapd.conf
echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" | sudo tee /etc/default/hostapd
echo '#!/bin/bash
sudo systemctl stop hostapd.service
sudo systemctl stop dnsmasq.service
sudo systemctl stop dhcpcd.service
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X
sudo iw dev wap0 del
sudo iw dev '$WLN' interface add wap0 type __ap
sudo sysctl net.ipv4.ip_forward=1
sudo sysctl net.ipv4.conf.all.route_localnet=1
sudo iptables -t nat -I PREROUTING -p tcp --dport 1024:10000 -j DNAT --to 10.0.0.2:1024-10000
sudo iptables -t nat -I PREROUTING -p udp --dport 1024:10000 -j DNAT --to 10.0.0.2:1024-10000
sudo iptables -t nat -A POSTROUTING -s 10.0.0.0/24 ! -d 10.0.0.0/24 -j MASQUERADE
sudo systemctl start hostapd.service
sudo systemctl start dhcpcd.service
sudo systemctl start dnsmasq.service' | sudo tee /etc/startap.sh
sudo sed -i 's^"exit 0"^"exit"^g' /etc/rc.local
sudo sed -i 's^sudo bash /etc/startap.sh \&^^g' /etc/rc.local
sudo sed -i 's^exit 0^sudo bash /etc/startap.sh \& \n\nexit 0^g' /etc/rc.local
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo update-rc.d hostapd disable
echo -e '\033[32mWifi AP installed\033[0m'
break;;
[Nn]* ) echo -e '\033[35mSkipping Wifi AP install\033[0m'
break;;
* ) echo -e '\033[31mPlease answer Y or N\033[0m';;
esac
done
while true; do
read -p "$(printf '\r\n\r\n\033[36mDo you want to install a FTP server? (Y|N):\033[0m ')" ftpq
case $ftpq in
[Yy]* ) 
sudo apt-get install vsftpd -y
echo "local_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=077
allow_writeable_chroot=YES
chroot_local_user=YES
user_sub_token=$USER
local_root=/var/www/html" | sudo tee /etc/vsftpd.conf
sudo chmod 775 /var/www/html/
USR=$(sudo groupmems -g users -l | cut -f1 -d' ')
sudo sed -i 's^exit 0^^g' /etc/rc.local
sudo sed -i 's^sudo chown -R '$USR':'$USR' /var/www/html/^^g' /etc/rc.local
echo -e "sudo chown -R "$USR":"$USR" /var/www/html/\n\nexit 0" | sudo tee -a /etc/rc.local
echo -e '\033[32mFTP Installed\033[0m'
break;;
[Nn]* ) echo -e '\033[35mSkipping FTP install\033[0m'
break;;
* ) echo -e '\033[31mPlease answer Y or N\033[0m';;
esac
done
while true; do
read -p "$(printf '\r\n\r\n\033[36mnDo you want to setup a SAMBA share? (Y|N):\033[0m ')" smbq
case $smbq in
[Yy]* ) 
sudo apt-get install samba samba-common-bin -y
echo '[global]
;   interfaces = 127.0.0.0/8 eth0
;   bind interfaces only = yes
   log file = /var/log/samba/log.%m
   max log size = 1000
   logging = file
   panic action = /usr/share/samba/panic-action %d
   server role = standalone server
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   pam password change = yes
   map to guest = bad user
;   logon path = \\%N\profiles\%U
;   logon drive = H:
;   logon script = logon.cmd
; add user script = /usr/sbin/useradd --create-home %u
; add machine script  = /usr/sbin/useradd -g machines -c "%u machine account" -d /var/lib/samba -s /bin/false %u
; add group script = /usr/sbin/addgroup --force-badname %g
;   include = /home/samba/etc/smb.conf.%m
;   idmap config * :              backend = tdb
;   idmap config * :              range   = 3000-7999
;   idmap config YOURDOMAINHERE : backend = tdb
;   idmap config YOURDOMAINHERE : range   = 100000-999999
;   template shell = /bin/bash
   usershare allow guests = yes
[homes]
   comment = Home Directories
   browseable = no
   read only = yes
   create mask = 0700
   directory mask = 0700
   valid users = %S
;[netlogon]
;   comment = Network Logon Service
;   path = /home/samba/netlogon
;   guest ok = yes
;   read only = yes
;[profiles]
;   comment = Users profiles
;   path = /home/samba/profiles
;   guest ok = no
;   browseable = no
;   create mask = 0600
;   directory mask = 0700
[printers]
   comment = All Printers
   browseable = no
   path = /var/tmp
   printable = yes
   guest ok = no
   read only = yes
   create mask = 0700
[print$]
   comment = Printer Drivers
   path = /var/lib/samba/printers
   browseable = yes
   read only = yes
   guest ok = no
;   write list = root, @lpadmin
[www]
path = /var/www/html
writeable=Yes
create mask=0777
read only = no
directory mask=0777
force create mask = 0777
force directory mask = 0777
force user = root
force group = root
public=yes' | sudo tee /etc/samba/smb.conf
sudo systemctl unmask smbd
sudo systemctl enable smbd
echo -e '\033[32mSamba installed\033[0m'
break;;
[Nn]* ) echo -e '\033[35mSkipping SAMBA install\033[0m'
break;;
* ) echo -e '\033[31mPlease answer Y or N\033[0m';;
esac
done
HSTN=$(hostname | cut -f1 -d' ')
if [[ ! $HSTN == "ps5" ]] ;then
sudo sed -i "s^$HSTN^ps5^g" /etc/hosts
sudo sed -i "s^$HSTN^ps5^g" /etc/hostname
fi
echo -e '\033[36mInstall complete,\033[33m Rebooting\033[0m'
sudo reboot
