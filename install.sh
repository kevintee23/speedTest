#!/bin/bash

# Install script for speedtest
# by de_man
# 23/4/2019

cd

echo '[+] Installing and updating core dependencies...'
apt-get update && apt-get -y upgrade

echo '[+] Installing npm...'
sudo apt-get install npm

echo '[+] Installing pip and gunicorn...'
sudo apt-get install python-pip gunicorn

echo '[+] Downloading the latest and stable version of nodejs...'
sudo npm cache clean -f
sudo npm install -g n

echo '[+] Installing stable version of nodejs...'
sudo n stable

echo '[+] Installing speedtest script...'
sudo npm install -global fast-speedtest-api

echo '[+] Installing flask...'
sudo pip install flask

echo '[+] Cloning gunicorn service file to the appropriate folder'
sudo cp /home/pi/speedtest/gunicorn.service /etc/systemd/system/

echo 'May the force be with you...'
