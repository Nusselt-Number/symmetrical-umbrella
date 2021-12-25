#!/bin/bash
#This script is for first time set up of a new droplet on digital ocean.  But it should work for most debian based distros.
#It requires a single $1 parameters when the script is called. 
#This is the name of an existing user who will become the sudo and ssh access point user, while disabling root logon.
#This script is intended to be run as root or prefixed with sudo, it does not include any sudos in it at this time.

#Check to make sure the name provided exists
if id "$1" &>/dev/null; then
    echo 'user found'
else
    echo 'user not found'
    exit 5
fi

#Reassign user argument to a variable.
someone="$1"

#Add the user to the sudo group.
adduser $someone sudo

#Copy the keys from root login to our new sudoheck what distro I'm on user's key file.
mkdir -p /home/$someone/.ssh && cp /root/.ssh/authorized_keys /home/$someone/.ssh/authorized_keys

#Disable root login via ssh by modifying the sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

#Make sure the user owns the contents of their key file
chown -R $someone:$someone /home/$someone/.ssh/* && chmod -R 0600 /home/$someone/.ssh/*

###Install and setup the firewall

#First check for updates, then install
apt update
apt install ufw

#Next setup our default rules
ufw default deny incoming
ufw default allow outgoing
ufw limit ssh

#Lastly enable the firewall and then reload
ufw enable
ufw reload