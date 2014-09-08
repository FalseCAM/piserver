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
tar -xvf btsync_arm.tar.gz -C /usr/bin btsync

sed -i "s/dc=example,dc=org/${ldapdc}/g" "run_btsync.php"
sed -i "s/password/${pw_ldap_admin}/g" "run_btsync.php"
cp btsync /etc/init.d
chmod +x /etc/init.d/btsync

# install crontab to restart daily
(crontab -l ; echo "0 */2 * * * /etc/init.d/btsync restart")| crontab - 

rm -rf btsync_arm.tar.gz