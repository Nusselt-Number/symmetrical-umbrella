#!/bin/bash
#This script is intended to add non-free and contrib repos to the main debian sources list file.  It runs with sudo and and assumes sources are located in /etc/apt/sources.list .

#Modify sources list
sudo sed -i 's/main/main contrib non-free/' /etc/apt/sources.list

#Update and upgrade apt lists
sudo apt update && sudo apt upgrade -qq -y

