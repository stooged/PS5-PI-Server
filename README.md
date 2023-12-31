# PS5 PI Server


this is an install script to setup a dns server(blocker), web server and a exploit host on a raspberry pi.


it is using <a href=https://github.com/idlesauce/PS5-Exploit-Host>PS5-Exploit-Host</a> by idlesauce.


## Repo Setup

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



<br>

### Raspberry PI
<hr>

run the raspberry pi install script

```
chmod 777 install.sh
sudo ./install.sh

```


tested on raspberry pi os lite
<a href=https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2023-12-11/2023-12-11-raspios-bookworm-arm64-lite.img.xz>2023-12-11-raspios-bookworm-arm64-lite.img.xz</a>



<br>

### Rock PI
<hr>


if you happen to have a <a href=https://wiki.radxa.com/Rock4/4cplus>ROCK 4C Plus</a> then you can run this install script

```
chmod 777 installrock.sh
sudo ./installrock.sh
```

tested on debian bullseye
<a href=https://github.com/radxa-build/rock-4c-plus/releases/download/b60/rock-4c-plus_debian_bullseye_cli_b60.img.xz>rock-4c-plus_debian_bullseye_cli_b60.img.xz</a>

<br><br>



### BTT PI
<hr>


if you happen to have a <a href=https://biqu.equipment/en-au/products/bigtreetech-btt-pi-v1-2>BTT Pi</a> then you can run this install script

```
chmod 777 installbtt.sh
sudo ./installbtt.sh
```

tested on debian 11 minimal
<a href=https://github.com/bigtreetech/CB1/releases/download/V2.3.3/CB1_Debian11_minimal_kernel5.16_20230712.img.xz>CB1_Debian11_minimal_kernel5.16_20230712.img.xz</a>

<br><br>



### Samba
<hr>

if you wish to enable samba to access the www folder for the exploit files/payloads then run this script.


```
cd PS5-PI-Server
chmod 777 setup_Samba.sh
sudo ./setup_Samba.sh
```

once completed you can access the drive on \\\ps5.local\www or smb:\\\ps5.local\www<br>
the share has no user/password required to access it.

<br><br>


### Wifi AP
<hr>


if you want to connect the console directly to the pi using wifi then you can setup a wifi access point on the pi.<br>
this setup assumes you are connecting the pi to your home network using an ethernet cable not wifi.


```
cd PS5-PI-Server
chmod 777 setup_wifiAP.sh
sudo ./setup_wifiAP.sh
```

the default settings are<br>
ssid=PS5_WEB_AP<br>
wpa_passphrase=password<br>

if you want to change those then after you run the setup_wifiAp script you can run the following command to edit those values then reboot the pi.

```
sudo nano /etc/hostapd/hostapd.conf
```

<br><br>

## Console DNS

you should be able to access the exploit page on http://ps5.local

if you are not using the wifi AP then edit the dns settings on your ps5 to the ip of the pi and you can then go to the user guide to run the exploit.



