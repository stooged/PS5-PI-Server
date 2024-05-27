# PS5 PI Server


this is an install script to setup a dns server(blocker), web server, wifi access point and a exploit host on a raspberry pi.<br>

the script will prompt you to install a ftp server and setup a samba share to access the exploit/payload files.<br>
you can setup either one or both or none at all.<br>


it is using <a href=https://github.com/idlesauce/PS5-Exploit-Host>PS5-Exploit-Host</a> by idlesauce.



## Tested PI Models

<a href=https://www.raspberrypi.com/products/raspberry-pi-5/>Raspberry Pi 5</a><br>
<a href=https://www.raspberrypi.com/products/raspberry-pi-4-model-b/>Raspberry Pi 4 Model B</a><br>
<a href=https://www.raspberrypi.com/products/raspberry-pi-400/>Raspberry Pi 400</a><br>
<a href=https://www.raspberrypi.com/products/raspberry-pi-3-model-b-plus/>Raspberry Pi 3B+</a><br>
<a href=https://www.raspberrypi.com/products/raspberry-pi-2-model-b/>Raspberry Pi 2 Model B</a><br>
<a href=https://www.raspberrypi.com/products/raspberry-pi-zero-2-w/>Raspberry Pi Zero 2 W</a><br>
<a href=https://wiki.radxa.com/Rock4/4cplus>ROCK PI 4C Plus</a> with armbian <a href=https://imola.armbian.com/archive/rockpi-4cplus/archive/Armbian_23.11.1_Rockpi-4cplus_bookworm_current_6.1.63.img.xz>Image</a><br>
<a href=https://biqu.equipment/products/bigtreetech-btt-pi-v1-2>BIGTREETECH BTT Pi V1.2</a> with armbian <a href=https://www.armbian.com/bigtreetech-cb1/>minimal</a><br>

## Install

You need to install <a href=https://www.raspberrypi.com/software/operating-systems/>Raspberry Pi OS Lite</a> or <a href="https://www.armbian.com/">Armbian Cli / Minimal</a> onto a sd card.<br>


it may work on other variants of pi type hardware if you can find the armbian image to suit that board.

<br>

during the first run of armbian if you are asked to "choose the default system command shell" make sure you select <b>bash</b> which is normally option 1

if you are using the <a href=https://biqu.equipment/en-au/products/bigtreetech-btt-pi-v1-2>BTT Pi</a> and you setup a wifi connection to your home network use wlan0 because wlan1 will be used for the wifi access point.

<br><br>

boot up the pi and set your credentials then login using a keyboard/screen on the pi or use <a href=http://putty.org>putty</a> or something similar to access ssh remotely.


once you have done that just run the following commands:
<br>


```sh
sudo apt update
sudo apt install git -y
sudo git clone https://github.com/stooged/PS5-PI-Server
cd PS5-PI-Server
sudo chmod 777 install.sh
sudo bash install.sh

```


<br><br>


## Console FTP / Elfload / PKG Install

you can access the ftp, klog, Elfload, Pkg install servers on the console<br>
Your pi must be connected to your home network via wifi or a second ethernet connection<br>
To connect to the servers from your pc just connect to the raspberry pi ip on your network and all requests will be forwarded to the console<br>

For ftp make sure you set the transfer mode on your ftp client software to `Active` not passive.<br>

<br><br>


### PI FTP
<hr>

if you install FTP to access the www folder for the exploit files/payloads you can use your pi login user/pass to access the server.<br>

<br><br>


### PI Samba
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

