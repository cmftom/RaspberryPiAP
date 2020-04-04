#!/bin/bash

###########################################
# THIS IS THE HOST SETUP AP FILE
###########################################

#update packages
apt-get update

#install package
sudo apt -y install dnsmasq hostapd

sudo systemctl stop dnsmasq
sudo systemctl stop hostapd

#Config the static IP for wifi
#sudo nano /etc/dhcpcd.conf
echo "interface wlan0" >> /etc/dhcpcd.conf
echo "    static ip_address=192.168.2.1/24" >> /etc/dhcpcd.conf
echo "    netmask 255.255.255.0" >> /etc/dhcpcd.conf
echo "    gateway 0.0.0.0" >> /etc/dhcpcd.conf
echo "    nohook wpa_supplicant" >> /etc/dhcpcd.conf

#the Eth static ip config
#echo "interface eth0" >> /etc/dhcpcd.conf
#echo "    static ip_address=192.168.2.1/24" >> /etc/dhcpcd.conf
#echo "    netmask 255.255.255.0" >> /etc/dhcpcd.conf
#echo "    gateway 0.0.0.0" >> /etc/dhcpcd.conf
#echo "    nohook wpa_supplicant" >> /etc/dhcpcd.conf

#Restart the server
sudo /etc/init.d/dnsmasq restart
sudo service dhcpcd restart

#Config DHCP
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
echo "interface=wlan0      # Use the require wireless interface - usually wlan0" >> /etc/dnsmasq.conf
echo "dhcp-range=192.168.2.2,192.168.2.10,255.255.255.0,24h" >> /etc/dnsmasq.conf

#Reload the dnsmasq
sudo systemctl reload dnsmasq

#Setup the hostapd
echo "#AutoHotspot config" >> /etc/hostapd/hostapd.conf
echo "interface=wlan0" >> /etc/hostapd/hostapd.conf
echo "driver=nl80211" >> /etc/hostapd/hostapd.conf
echo "ssid=RaspAP" >> /etc/hostapd/hostapd.conf
echo "hw_mode=g" >> /etc/hostapd/hostapd.conf
echo "channel=7" >> /etc/hostapd/hostapd.conf
echo "wmm_enabled=0" >> /etc/hostapd/hostapd.conf
echo "macaddr_acl=0" >> /etc/hostapd/hostapd.conf
echo "auth_algs=1" >> /etc/hostapd/hostapd.conf
echo "ignore_broadcast_ssid=0" >> /etc/hostapd/hostapd.conf
echo "wpa=2" >> /etc/hostapd/hostapd.conf
echo "wpa_passphrase=raspberry" >> /etc/hostapd/hostapd.conf
echo "wpa_key_mgmt=WPA-PSK" >> /etc/hostapd/hostapd.conf
echo "wpa_pairwise=TKIP" >> /etc/hostapd/hostapd.conf
echo "rsn_pairwise=CCMP" >> /etc/hostapd/hostapd.conf

#Config path
echo 'DAEMON_CONF="/etc/hostapd/hostapd.conf"' >> /etc/default/hostapd

#Start the hostapd up
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd

#Add routing 
echo "net.ipv4.ip_forward=1" >>  /etc/sysctl.conf

sudo iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

echo "Add the line at before the exit 0 at /etc/rc.local"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "iptables-restore < /etc/iptables.ipv4.nat"
