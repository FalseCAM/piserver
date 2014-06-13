#!/bin/bash
# this script runs all setup scripts.
# you can comment out scripts you dont want to run by adding '#'.

# check if this script runs as root
if ! [ $(id -u) = 0 ]; then
  echo "You have to run this script as root user."
  exit 1
fi

# first configure your raspbian
raspi-config

# update your system
apt-get update && apt-get upgrade


# configure system
sh configure_system.sh

# generate passwords for all services.
sh generate_passwords.sh

# install certificates
sh install_certs.sh

# install and configure ldap
sh install_ldap.sh

# install apache
sh install_apache.sh

# install webmin
sh install_webmin.sh

# install bittorrent sync
sh install_btsync.sh

# install owncloud
sh install_owncloud.sh

# install fail2ban
sh install_fail2ban.sh