#!/bin/bash

sudo apt install hostapd dhcpcd iptables netfilter-persistent -y
echo -e "\r\ninterface wlan0
    static ip_address=10.0.0.1/24
    nohook wpa_supplicant" | sudo tee -a /etc/dhcpcd.conf
echo -e "\r\ninterface=wlan0\r\ndhcp-range=10.0.0.2,10.0.0.20,255.255.255.0,24h" | sudo tee -a /etc/dnsmasq.conf
echo "country_code=US
interface=wlan0
ssid=PS5_WEB_AP
channel=9
auth_algs=1
wpa=2
wpa_passphrase=password
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
rsn_pairwise=CCMP" | sudo tee -a /etc/hostapd/hostapd.conf
echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" | sudo tee -a /etc/default/hostapd
sudo sed -i 's^exit 0^sudo iptables-restore < ./etc/iptables.ipv4.nat\r\n\sudo ifconfig wlan0 up\r\nsudo ./sbin/hostapd /etc/hostapd/hostapd.conf \& \n\nexit 0^g' /etc/rc.local
sudo sed -i 's^#net.ipv4.ip_forward=1^net.ipv4.ip_forward=1^g' /etc/sysctl.conf
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
sudo netfilter-persistent save
sudo service dhcpcd restart
sudo systemctl restart dnsmasq
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd





