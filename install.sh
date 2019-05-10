#!/bin/bash

# Install script for speedtest
# by de_man
# 10/5/2019

#Informational only, getting your IP Address
ip=$(hostname -I | cut -f1 --delimiter=' ')
echo "Your Raspberry Pi IP Address is $ip"

#COLORS
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan

cd ~

echo -e "$Cyan \nThe default location for the installation files is /home/pi $Color_Off"
echo -e "$Cyan Enter below the directory name beneath this location where you want to install speedTest $Color_Off"
echo -e "$Cyan If you want speedTest installed in /home/pi/speedtest, enter $Color_Off speedtest $Cyan below. $Color_Off"
echo -e "$Cyan or... if you prefer a different name, like $Color_Off speed $Cyan , enter $Color_Off speed $Cyan below. $Color_Off"
stdir="speedtest"
read -p " Directory name for speedTest (default= $stdir): " nstdir
[ -n "$nstdir" ] && stdir=$nstdir
mkdir /home/pi/$stdir
echo -e "$Purple Installation files are now located at /home/pi/$stdir $Color_Off"

cd ~

echo -e "$Cyan You will now need your fast.com token. $Color_Off"
fastToken="3nt3ry0urt0k3nh3r3"
read -p "Enter your fast.com token (default=$fastToken): " nfastToken
[ -n "$nfastToken" ] && fastToken=$nfastToken
echo -e "$Purple >>>Your fast.com token is $Color_Off $fastToken"

echo -e "$Cyan The service, by default will run on port 5000. You can set a different port here. $Color_Off"
ipport="5000"
read -p "Enter the port that the service should run on (default:5000): " nipport
[ -n "$nipport" ] && ipport=$nipport
echo -e "$Purple The service will be configured to run on port $ipport $Color_Off"

echo -e "$Cyan[+] Installing and updating core dependencies...$Color_Off"
sudo apt-get update && sudo apt-get -y upgrade

echo -e "$Cyan[+] Installing npm...$Color_Off"
sudo apt-get install -y npm

echo -e "$Cyan[+] Installing python...$Color_Off"
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo python3 get-pip.py

echo -e "$Cyan[+] Installing gunicorn...$Color_Off"
sudo apt-get install -y gunicorn

echo -e "$Cyan[+] Downloading the latest and stable version of nodejs...$Color_Off"
sudo npm cache clean -f
sudo npm install -g n

echo -e "$Cyan[+] Installing stable version of nodejs...$Color_Off"
sudo n stable

echo -e "$Cyan[+] Installing the speedtest script...$Color_Off"
sudo npm install -global fast-speedtest-api

echo -e "$Cyan[+] Installing flask...$Color_Off"
sudo python -m pip install flask

echo -e "$Cyan[+] Writing relevant and required files...$Color_Off"
cd ~
cd /home/pi/$stdir
echo -e "$Cyan Creating service file - gunicorn.service... $Color_Off"
sudo echo "[Unit]" > gunicorn-speedtest.service
sudo echo "Description=gunicorn daemon for speedtest" >> gunicorn-speedtest.service
sudo echo "After=network.target" >> gunicorn-speedtest.service
sudo echo " " >> gunicorn-speedtest.service
sudo echo "[Service]" >> gunicorn-speedtest.service
sudo echo "User=pi" >> gunicorn-speedtest.service
sudo echo "Group=www-data" >> gunicorn-speedtest.service
sudo echo "RuntimeDirectory=gunicorn" >> gunicorn-speedtest.service
sudo echo "WorkingDirectory=/home/pi/$hpdir" >> gunicorn-speedtest.service
sudo echo "ExecStart=/usr/bin/gunicorn -b 0.0.0.0:$ipport speedtest:app" >> gunicorn-speedtest.service
sudo echo "ExecReload=/bin/kill -s HUP $MAINPID" >> gunicorn-speedtest.service
sudo echo "ExecStop=/bin/kill -s TERM $MAINPID" >> gunicorn-speedtest.service
sudo echo " " >> gunicorn-speedtest.service
sudo echo "[Install]" >> gunicorn-speedtest.service
sudo echo "WantedBy=multi-user.target" >> gunicorn-speedtest.service
sudo chmod 755 gunicorn-speedtest.service
echo -e "$Purple gunicorn.service file created successfully in /home/pi/$stdir $Color_Off"

cd ~
cd /home/pi/$stdir
echo -e "$Cyan Creating speedtest script - speedtest.py... $Color_Off"
sudo echo "import process" > speedtest.py
sudo echo "import os" >> speedtest.py
sudo echo "" >> speedtest.py
sudo echo "from flask import Flask" >> speedtest.py
sudo echo "app = Flask(__name__)" >> speedtest.py
sudo echo "" >> speedtest.py
sudo echo "@app.route('/')" >> speedtest.py
sudo echo "def speedTest():" >> speedtest.py
sudo echo "   return subprocess.Popen('/usr/local/bin/fast-speedtest $fastToken', shell=True, stdout=subprocess.PIPE).stdout.read()" >> speedtest.py
sudo chmod +x speedtest.py
echo -e "$Purple speedtest.py script was created successfully in /home/pi/$stdir $Color_Off"

cd ~
cd /home/pi/$stdir
echo -e "$Cyan Creating readme file... $Color_Off"
sudo echo "Visit this website for more information -" >> README.md
sudo echo "http://www.mysmartcave.net/2019/04/27/performing-a-speedtest-using-google-home-and-or-alexa/" >> README.md

cd ~
echo -e "$Cyan[+] Cloning gunicorn service file to the appropriate folder...$Color_Off"
sudo cp /home/pi/$stdir/gunicorn-speedtest.service /etc/systemd/system/

echo -e "$Cyan[+] Auto starting service...$Color_Off"
cd /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl start gunicorn-speedtest
sudo systemctl enable gunicorn-speedtest

echo -e "$Cyan[+] Removing install script...$Color_Off"
cd ~
rm -v install.sh

echo -e "$Green The service has been successfully installed. To run this service, $Color_Off"
echo -e "$Green open a browser and type in the following: $Color_Off"
echo -e "$Purple $ip:$ipport $Color_Off"

echo -e "$Green May the force be with you...$Color_Off"
