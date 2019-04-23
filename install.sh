#!/bin/bash

# Install script for speedtest
# by de_man
# 23/4/2019

echo '[+] Installing and updating core dependencies...'
apt-get update && apt-get -y upgrade

echo '[+] Installing npm, pip and gunicorn...'
sudo apt-get install npm python-pip gunicorn

echo '[+] Downloading the latest and stable version of nodejs...'
sudo npm cache clean -f
sudo npm install -g n

echo '[+] Installing stable version of nodejs...'
sudo n stable

echo '[+] Installing speedtest script...'
sudo npm install -global fast-speedtest-api

echo '[+] Installing flask...'
sudo pip install flask
