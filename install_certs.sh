#!/bin/bash

tput setaf 2 && echo 'install certs' && tput setaf 7

# Install openssl if not exists
if ! type openssl > /dev/null; then
  sudo apt-get install openssl ssl-cert
fi

# create group for certificates
addgroup --system 'ssl-cert'

# create a self signed certificate
echo 'creating server certificate'
openssl req -newkey rsa:2048 -x509 -days 3650 -nodes -out /etc/ssl/certs/piserver.crt -keyout /etc/ssl/private/piserver.key

# change to group
chown -R root:ssl-cert '/etc/ssl/private'
chmod 710 '/etc/ssl/private'
chmod 440 '/etc/ssl/private/'*
chown root:ssl-cert "/etc/ssl/private/piserver.key"
chmod 440 "/etc/ssl/private/piserver.key"