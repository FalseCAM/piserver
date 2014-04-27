#!/bin/sh
# this script runs all setup scripts.
# you can comment out scripts you dont want to run by adding '#'.

# check if this script runs as root
if [[ $EUID -ne 0 ]]; then
  echo "You have to run this script as root user."
  exit 1
fi

# first configure your raspbian
raspi-config


# configure system
sh configure_system.sh

# generate passwords for all services.
sh generate_passwords.sh

# install and configure ldap
sh install_ldap.sh