#!/bin/bash

# Install openssl if not exists
if ! type openssl > /dev/null; then
  sudo apt-get install openssl
fi

# create directory to store created certifications
mkdir -p /etc/ssl/localcerts

# create a self signed certificate
openssl req -new -x509 -days 3650 -nodes -out /etc/ssl/localcerts/server.pem -keyout /etc/ssl/localcerts/server.key