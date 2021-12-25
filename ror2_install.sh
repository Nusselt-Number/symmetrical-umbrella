#!/bin/bash
#This script installs the Risk of Rain 2 dedicated server via SteamCMD alongside necessary dependencies.  It also opens ports for the game, 27015/udp, via ufw

#Install steamcmd and dependencies, then forward the correct port.
sudo apt update
sudo apt install steamcmd xvfb wine lib32gcc-s1 tmux
sudo ufw allow 27015/udp

#Next we can install the ROR2 dedicated server via the following 'automated' command
steamcmd +login anonymous +force_install_dir /home/ror2/ +@sSteamCmdForcePlatformType windows +app_update 1180760 +quit

#Can have the server start via
tmux xvfb-run wine ./"Risk of Rain 2.exe"

#Also want to investigate how to make a systemd service file for running this plus other games
