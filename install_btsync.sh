#!/bin/bash
# This script installs bittorrent sync

# load config file
. "./piserver.cfg"
#load ldap admin password
. "./passwords.cfg"

tput setaf 2 && echo 'install bittorrent sync' && tput setaf 7

# Install wget if not exists
if ! type wget > /dev/null; then
  sudo apt-get install wget
fi

# download btsync package
wget -O btsync_arm.tar.gz http://download-new.utorrent.com/endpoint/btsync/os/linux-arm/track/stable

# extract btsync
tar -xvf btsync_arm.tar.gz -C /usr/bin btsync

cp btsync_daemon /etc/init.d/btsync
chmod +x /etc/init.d/btsync

# install crontab to restart daily
(crontab -l 2>/dev/null; echo "0 */2 * * * /etc/init.d/btsync restart")| crontab - 

rm -rf btsync_arm.tar.gz