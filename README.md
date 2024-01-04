# PS5 PI Server


this is an install script to setup a dns server(blocker), web server, wifi access point and a exploit host on a raspberry pi, rock pi or btt pi.<br>
the script will prompt you to install a ftp server and setup a samba share to access the exploit/payload files.<br>
you can setup either one or both or none at all.<br>


it is using <a href=https://github.com/idlesauce/PS5-Exploit-Host>PS5-Exploit-Host</a> by idlesauce.


## Repo Setup

install an os onto the pi preferably the ones i have tested with as others might not work.

boot up the pi and set your credentials then login using a keyboard/screen on the pi or use <a href=http://putty.org>putty</a> or something similar to access ssh remotely.

run the following commands:


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

if you have a raspberry pi run this install script

```
sudo chmod 777 install.sh
sudo ./install.sh

```


tested on raspberry pi os lite
<a href=https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2023-12-11/2023-12-11-raspios-bookworm-arm64-lite.img.xz>2023-12-11-raspios-bookworm-arm64-lite.img.xz</a>

<br><br>


### Rock PI
<hr>


if you have a <a href=https://wiki.radxa.com/Rock4/4cplus>ROCK 4C Plus</a> run this install script

```
sudo chmod 777 installrock.sh
sudo ./installrock.sh
```

tested on debian bullseye
<a href=https://github.com/radxa-build/rock-4c-plus/releases/download/b60/rock-4c-plus_debian_bullseye_cli_b60.img.xz>rock-4c-plus_debian_bullseye_cli_b60.img.xz</a>

<br><br>


### BTT PI
<hr>


if you have a <a href=https://biqu.equipment/en-au/products/bigtreetech-btt-pi-v1-2>BTT Pi</a> run this install script

```
chmod 777 installbtt.sh
sudo ./installbtt.sh
```

if you setup a wifi connection to your home network use wlan0 because wlan1 will be used for the wifi access point.

built for armbian 23.11 bookworm minimal, use this image.
<a href=https://redirect.armbian.com/bigtreetech-cb1/Bookworm_legacy_minimal>Armbian_23.11.1_Bigtreetech-cb1_bookworm_legacy_6.1.43_minimal.img.xz</a>

<br><br>


### FTP
<hr>

if you install FTP to access the www folder for the exploit files/payloads you can use your pi login user/pass to access the server.<br>

<br><br>


### Samba
<hr>

if you setup samba to access the www folder for the exploit files/payloads you can access the drive on \\\ps5.local\www or smb:\\\ps5.local\www<br>
the share has no user/password required to access it.

<br><br>


### Wifi AP
<hr>

if you do not set the SSID and password during the install the default settings are<br>

ssid=PS5_WEB_AP<br>
wpa_passphrase=password<br>

if you want to change those settings you can run the following command to edit those values then reboot the pi for the changes to take effect.


```
sudo nano /etc/hostapd/hostapd.conf
```

the SSID must be between 2 and 32 characters long.<br>
the password must be between 8 and 63 characters long.

<br><br>


## Console DNS

you should be able to access the exploit page on http://ps5.local

if you are not using the wifi AP then edit the dns settings on your ps5 to the ip of the pi and you can then go to the user guide to run the exploit.



