#!/bin/bash

sudo apt install dnsmasq -y
sudo apt-get install nginx -y
sudo sed -i 's/#domain-needed/domain-needed/g' /etc/dnsmasq.conf
sudo sed -i 's/#bogus-priv/bogus-priv/g' /etc/dnsmasq.conf
sudo sed -i 's/#expand-hosts/expand-hosts/g' /etc/dnsmasq.conf
sudo sed -i 's^#conf-file=/etc/dnsmasq.more.conf^conf-file=/etc/dnsmasq.more.conf^g' /etc/dnsmasq.conf
sudo openssl req -subj "/C=US/O=ps5/CN=ps5.local" -x509 -nodes -days 8192 -newkey rsa:2048 -keyout /etc/nginx/sites-available/cert.key -out /etc/nginx/sites-available/cert.crt
sudo sed -i 's/# listen 443 ssl/ listen 443 ssl/g' /etc/nginx/sites-available/default
sudo sed -i 's/# listen \[::\]:443 ssl/ listen \[::\]:443 ssl/g' /etc/nginx/sites-available/default
sudo sed -i 's/server_name _/server_name ps5.local/g' /etc/nginx/sites-available/default
sudo sed -i 's^# SSL configuration^# SSL configuration\r\n	 ssl_certificate /etc/nginx/sites-available/cert.crt;\r\n	 ssl_certificate_key /etc/nginx/sites-available/cert.key;^g' /etc/nginx/sites-available/default
sudo cp dstart.sh /etc/
sudo cp -r document /var/www/html/
sudo touch /var/www/html/index.html
echo "<html><meta HTTP-EQUIV='REFRESH' content='0; url=/document/index.html'></html>" | sudo tee -a /var/www/html/index.html
sudo sed -i 's^"exit 0"^^g' /etc/rc.local
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
sudo sed -i 's^rock-4c-plus^ps5^g' /etc/hosts
sudo sed -i 's^rock-4c-plus^ps5^g' /etc/hostname
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
sudo systemctl mask systemd-resolved
echo "Install complete, Rebooting"
sudo reboot











