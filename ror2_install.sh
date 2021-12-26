#!/bin/bash
#This script installs the Risk of Rain 2 dedicated server via SteamCMD alongside necessary dependencies.  It also opens ports for the game, 27015/udp, via ufw

#Install steamcmd and dependencies, then forward the correct port.
sudo add-apt repository multiverse #Add Ubuntu non-free
sudo dpkg --add-architecture i386 #Add i386 architecture, 32 bit support
sudo apt-get update
sudo apt-get install -y steamcmd xvfb wine lib32gcc-s1 tmux
sudo ufw allow 27015:27016/udp

#Next we can install the ROR2 dedicated server via the following 'automated' command
steamcmd +login anonymous +force_install_dir /home/ror2/ +@sSteamCmdForcePlatformType windows +app_update 1180760 +quit

#Can have the server start via
tmux xvfb-run wine ./"Risk of Rain 2.exe"

#Also want to investigate how to make a systemd service file for running this plus other games
