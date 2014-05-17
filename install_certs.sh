#!/bin/bash

tput setaf 2 && echo 'install certs' && tput setaf 7

# Install openssl if not exists
if ! type openssl > /dev/null; then
  sudo apt-get install openssl
fi

# create directory to store created certifications
mkdir -p /etc/ssl/localcerts

# create a self signed certificate
echo 'creating server certificate'
openssl req -newkey rsa:2048 -x509 -days 3650 -nodes -out /etc/ssl/localcerts/piserver.crt -keyout /etc/ssl/localcerts/piserver.key
