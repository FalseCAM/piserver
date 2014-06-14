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
wget http://btsync.s3-website-us-east-1.amazonaws.com/btsync_arm.tar.gz

# extract btsync
tar -xfv btsync_arm.tar.gz
mv LICENSE.txt btsync-LICENSE.txt

# move btsync to /usr/bin folder
mv btsync* /usr/bin
sed -i "s/dc=example,dc=org/${ldapdc}/g" "run_btsync.php"
sed -i "s/password/${pw_ldap_admin}/g" "run_btsync.php"
cp run_btsync.php /usr/bin
chmod 700 /usr/bin/run_btsync.php

# install crontab to restart daily
crontab -l | { cat; echo "0 */2 * * * php5 /usr/bin/run_btsync.php"; } | crontab -