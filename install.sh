#!/bin/bash

# Install script for speedtest
# by de_man
# 23/4/2019

cd

echo '[+] Installing and updating core dependencies...'
apt-get update && apt-get -y upgrade

echo '[+] Installing npm...'
sudo apt-get install -y npm

echo '[+] Installing python...'
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo python3 get-pip.py

echo '[+] Installing gunicorn...'
sudo apt-get install -y gunicorn

echo '[+] Downloading the latest and stable version of nodejs...'
sudo npm cache clean -f
sudo npm install -g n

echo '[+] Installing stable version of nodejs...'
sudo n stable

echo '[+] Installing speedtest script...'
sudo npm install -global fast-speedtest-api

echo '[+] Installing flask...'
sudo python -m pip install flask

echo '[+] Copying files...'
cd ~
mkdir /home/pi/speedTest
wget -O gunicorn.service -q --show-progress https://raw.github.com/kevintee23/speedTest/master/gunicorn.service
wget -O speedtest.py -q --show-progress https://raw.github.com/kevintee23/speedTest/master/speedtest.py
sudo chmod 755 gunicorn.service

echo '[+] Cloning gunicorn service file to the appropriate folder'
sudo cp /home/pi/speedTest/gunicorn.service /etc/systemd/system/

echo '[+] Auto starting service...'
cd /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl start gunicorn
sudo systemctl enable gunicorn

echo '[+] Removing install script...'
cd ~
rm -v install.sh

echo 'May the force be with you...'
