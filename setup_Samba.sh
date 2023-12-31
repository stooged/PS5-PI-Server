#!/bin/bash

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
sudo systemctl restart smbd