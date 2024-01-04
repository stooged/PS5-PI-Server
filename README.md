# PS5 PI Server


this is an install script to setup a dns server(blocker), web server, wifi access point and a exploit host on a <a href=https://www.raspberrypi.com/products/>Raspberry PI 3/4</a>, <a href=https://wiki.radxa.com/Rock4/4cplus>ROCK 4C Plus</a> or <a href=https://biqu.equipment/en-au/products/bigtreetech-btt-pi-v1-2>BTT Pi</a>.<br>

the script will prompt you to install a ftp server and setup a samba share to access the exploit/payload files.<br>
you can setup either one or both or none at all.<br>


it is using <a href=https://github.com/idlesauce/PS5-Exploit-Host>PS5-Exploit-Host</a> by idlesauce.


## Install

install the <a href="https://www.armbian.com/download/?device_support=Standard%20support">Armbian</a> os onto your pi

i have tested the following images:<br>
<a href=https://redirect.armbian.com/rpi4b/Bookworm_current>Raspberry PI3/4 image</a><br>
<a href=https://au.sbcmirror.org/armbian/dl/rockpi-4cplus/archive/Armbian_23.11.1_Rockpi-4cplus_bookworm_current_6.1.63.img.xz>Rock PI 4C+ image</a><br>
<a href=https://redirect.armbian.com/bigtreetech-cb1/Bookworm_legacy_minimal>BTT PI v1.2 image</a><br>

the install script will only work on <a href="https://www.armbian.com/download/?device_support=Standard%20support">Armbian</a>, it may work on other variants of raspberry pi hardware if you can find the armbian image to suit that board.

<br>

during the first run of armbian if you are asked to "choose the default system command shell" make sure you select <b>bash</b> which is normally option 1

if you are using the <a href=https://biqu.equipment/en-au/products/bigtreetech-btt-pi-v1-2>BTT Pi</a> and you setup a wifi connection to your home network use wlan0 because wlan1 will be used for the wifi access point.

<br><br>

boot up the pi and set your credentials then login using a keyboard/screen on the pi or use <a href=http://putty.org>putty</a> or something similar to access ssh remotely.


once you have done that just run the following commands:
<br>

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


run the install script

```
sudo chmod 777 install.sh
sudo ./install.sh

```


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

