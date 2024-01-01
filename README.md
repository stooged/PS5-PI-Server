# PS5 PI Server


this is an install script to setup a dns server(blocker), web server, wifi access point and a exploit host on a raspberry pi or rock pi.


it is using <a href=https://github.com/idlesauce/PS5-Exploit-Host>PS5-Exploit-Host</a> by idlesauce.


## Repo Setup

install an os onto the pi preferably a minimal or lite version(no desktop environment).

boot up the pi and set your credentials then use <a href=http://putty.org>putty</a> or something similar to access ssh.

once in ssh run the following commands:


install git

```
sudo apt update
sudo apt install git -y
```

clone this repo and enter the cloned directory

```
sudo git clone https://github.com/stooged/PS5-PI-Server
cd PS5-PI-Server
```



<br>

### Raspberry PI
<hr>

run the raspberry pi install script

```
sudo chmod 777 install.sh
sudo ./install.sh

```


tested on raspberry pi os lite
<a href=https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2023-12-11/2023-12-11-raspios-bookworm-arm64-lite.img.xz>2023-12-11-raspios-bookworm-arm64-lite.img.xz</a>



<br>

### Rock PI
<hr>


if you happen to have a <a href=https://wiki.radxa.com/Rock4/4cplus>ROCK 4C Plus</a> then you can run this install script

```
sudo chmod 777 installrock.sh
sudo ./installrock.sh
```

tested on debian bullseye
<a href=https://github.com/radxa-build/rock-4c-plus/releases/download/b60/rock-4c-plus_debian_bullseye_cli_b60.img.xz>rock-4c-plus_debian_bullseye_cli_b60.img.xz</a>

<br><br>




### Samba
<hr>

if you wish to enable samba to access the www folder for the exploit files/payloads then run this script.


```
cd PS5-PI-Server
sudo chmod 777 setup_Samba.sh
sudo ./setup_Samba.sh
```

once completed you can access the drive on \\\ps5.local\www or smb:\\\ps5.local\www<br>
the share has no user/password required to access it.

<br><br>


### Wifi AP
<hr>


the default settings are<br>
ssid=PS5_WEB_AP<br>
wpa_passphrase=password<br>

if you want to change those settings you can run the following command to edit those values then reboot the pi.

```
sudo nano /etc/hostapd/hostapd.conf
```

<br><br>

## Console DNS

you should be able to access the exploit page on http://ps5.local

if you are not using the wifi AP then edit the dns settings on your ps5 to the ip of the pi and you can then go to the user guide to run the exploit.



