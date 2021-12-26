#!/bin/bash
#This script is for first time set up of a new droplet on digital ocean.  But it should work for most debian based distros.
#It requires a single $1 parameters when the script is called that will be the sudo user's name and will disable root login.
#This script is intended to be run as root or prefixed with sudo, it does not include any sudos in it at this time.
#For example, you would run the script as "$ bash deb_setup.sh jack" to create a user named jack as root.

#Reassign user argument to a variable.
someone="$1"

#Check if the name provided is valid.
if [ someone != "" ]; then
    echo "The username: $someone is good"
else
    echo "Need to enter a username, exiting!"
    exit 5
fi
    

#Create the user, will prompt the user for a password and other information.
adduser $someone

#Add the user to the sudo group.
adduser $someone sudo


#Check to make sure the name provided exists
if id "$1" &>/dev/null; then
    echo "User: $someone found"
else
    echo "User: $someone not found, exiting!"
    exit 5
fi

#Copy the keys from root login to our new sudoheck what distro I'm on user's key file.
mkdir -p /home/$someone/.ssh && cp /root/.ssh/authorized_keys /home/$someone/.ssh/authorized_keys

#Disable root login via ssh by modifying the sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

#Make sure the user owns the contents of their key file
chown -R $someone:$someone /home/$someone/.ssh/* && chmod -R 0600 /home/$someone/.ssh/*

###Install and setup the firewall

#First check for updates, then install
apt-get update -y
apt-get install -y ufw

#Next setup our default rules
ufw default deny incoming
ufw default allow outgoing
ufw limit ssh

#Enable the firewall and reload the firewall plus ssh service
echo "y" | ufw enable
systemctl restart ssh

#Display end result
echo "User: "$someone" created"
echo "setup script finished!"