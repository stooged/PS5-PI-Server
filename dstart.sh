#!/bin/bash

sudo rm /etc/dnsmasq.more.conf

while [ "$(hostname -I)" = "" ]; do
  sleep 1
done

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

sudo service dnsmasq restart