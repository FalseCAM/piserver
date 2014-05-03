#!/bin/bash
# This script installs owncloud

tput setaf 2 && echo 'install owncloud' && tput setaf 7

# Install wget if not exists
if ! type wget > /dev/null; then
  sudo apt-get install wget
fi

# install needed packages
apt-get install apache2 php5 php5-common php5-gd php5-intl php5-mcrypt php5-cli php5-ldap curl libcurl3 libcurl4-openssl-dev php5-curl php-apc ffmpeg php-imagick

# install mysql
apt-get install mysql-client mysql-server php5-mysql

# download owncloud package
wget http://download.owncloud.org/community/owncloud-6.0.3.tar.bz2
# extract owncloud
tar xvf owncloud-6.0.3.tar.bz2

# copy owncloud to /var/www/
cp -r owncloud /var/www/
# change owner of files
chown -R www-data:www-data /var/www/