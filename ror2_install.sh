#!/bin/bash
#This script installs the Risk of Rain 2 dedicated server via SteamCMD alongside necessary dependencies.  It also opens ports for the game, 27015/udp, via ufw

#Install firewall and setup rules
sudo apt-get update-y
sudo apt-get install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing

#Allow ssh and ror2 server connections
sudo ufw limit ssh
sudo ufw allow 27015:27016/udp

#Enable the firewall
echo "y" | sudo ufw enable

#Install steamcmd and dependencies, then forward the correct port.
sudo add-apt-repository multiverse
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y xvfb wine lib32gcc1 

#Before we install steamcmd, need to preemptively accept the EULA/license with the following:
#echo steamcmd steam/license note '' | sudo debconf-set-selections
#echo steamcmd steam/question select "I AGREE" | sudo debconf-set-selection

sudo apt-get install -y steamcmd

#Next we can install the ROR2 dedicated server via the following 'automated' command
steamcmd +login anonymous +force_install_dir /home/steam/ +@sSteamCmdForcePlatformType windows +app_update 1180760 +quit
steamcmd +login anonymous +force_install_dir /home/steam/ +@sSteamCmdForcePlatformType windows +app_update 1007 +quit

#Copy the unit file into the etc/systemd/system directory.
sudo cp -r riskofrain2.service /etc/systemd/system/

#Add the server service with the following:
sudo systemctl enable riskofrain2.service

#Then start the server:
sudo systemctl enable riskofrain2.service