# PS5 PI Server


this is an install script to setup a dns server(blocker), web server and a exploit host on a raspberry pi.


it is using <a href=https://github.com/idlesauce/PS5-Exploit-Host>PS5-Exploit-Host</a> by idlesauce.


## Setup

install an os like Raspberry Pi OS Lite

boot up the pi and set your credentials then use putty or something similar to access ssh.

once in ssh run the following commands:


install git

```
sudo apt update
sudo apt install git -y
```

clone this repo and enter the cloned directory

```
git clone https://github.com/stooged/PS5-PI-Server
cd PS5-PI-Server
```

run the raspberry pi install script

```
chmod 777 install.sh
sudo ./install.sh

```

once the pi reboots you should be able to access it on http://ps5.local

edit the dns settings on your ps5 to the ip of the raspberry pi and you can then go to the user guide to run the exploit.



if you happen to have a <a href=https://wiki.radxa.com/Rock4/4cplus>ROCK 4C Plus</a> then you can run this install script

```
chmod 777 installrock.sh
sudo ./installrock.sh
```

tested on debian bullseye
<a href=https://github.com/radxa-build/rock-4c-plus/releases/download/b60/rock-4c-plus_debian_bullseye_cli_b60.img.xz>rock-4c-plus_debian_bullseye_cli_b60.img.xz</a>