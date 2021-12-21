#!/bin/bash
#This script install ufw and sets up default rules, including only allowing in limited ssh traffic.

#First check for updates, then install
apt update
apt install ufw

#Next setup our default rules
ufw default deny incoming
ufw default allow outgoing
ufw limit ssh

#Lastly enable the firewall and then check the status
ufw enable
ufw status
