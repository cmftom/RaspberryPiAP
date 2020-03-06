# RaspberryPiAP

This bash file is going to setup Access Point for raspberry pi
The default SSID and psk:
*SSID `RaspAP`
*PSK `raspberrry`

## Modify the SSID and PSK
Change the name and psk with yours by change the ****
```sh
$nano /RaspAP/AP.sh

echo "ssid=****" >> /etc/hostapd/hostapd.conf
echo "wpa_passphrase=****" >> /etc/hostapd/hostapd.conf
```
## Run the bash file
```sh
$mkdir RaspAP
$cd RaspAP 
$sudo apt-get install git 
$git clone https://github.com/cmftom/RaspberryPiAP
$cd RaspberryPiAP
$chmod +x AP.sh
$./AP.sh
```
## Reboot the Raspberry Pi and check the wifi SSID is shown on the list
```sh
$sudo reboot now
```
