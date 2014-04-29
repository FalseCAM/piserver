#!/bin/sh
# This script installs webmin

# Install slapd if not exists
if ! type wget > /dev/null; then
  sudo apt-get install wget
fi

# download webmin package
wget http://www.webmin.com/download/deb/webmin-current.deb
# install webmin package
sudo dpkg --install webmin-current.deb

# install needed packages
sudo apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python