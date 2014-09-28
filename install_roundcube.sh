#!/bin/bash
# This script installs roundcube webmail

# load config file
. "./piserver.cfg"
#load ldap admin password
. "./passwords.cfg"

tput setaf 2 && echo 'install roundcube' && tput setaf 7

# download and extract roundcube
mkdir /var/www/roundcube
cd /var/www/roundcube
wget http://sourceforge.net/projects/roundcubemail/files/roundcubemail/1.0.2/roundcubemail-1.0.2.tar.gz
tar xvf roundcubemail-1.0.2.tar.gz
cd roundcubemail-1.0.2
mv {.,}* ..
cd ..
rmdir roundcubemail-1.0.2
rm roundcubemail-1.0.2.tar.gz

#create roundcube database user
mysql -u root -p
## create database and user
#
# mysql> CREATE DATABASE IF NOT EXISTS roundcube;
# mysql> GRANT ALL PRIVILEGES ON roundcube.* TO 'roundcube'@'localhost'   IDENTIFIED BY 'password';
# mysql> FLUSH PRIVILEGES;
# mysql> quit
#

mysql -u roundcube -p "password" roundcube < /var/www/roundcube/SQL/mysql.initial.sql

#
cp config/config.inc.php.sample config/config.inc.php

sed -i "s/$rcmail_config['db_dsnw'] = 'mysql:\/\/roundcube:pass@localhost\/roundcubemail';/$rcmail_config['db_dsnw'] = 'mysqli:\/\/roundcube:password@localhost\/roundcube/g" "/etc/sysctl.conf"

# webmail site
echo "<VirtualHost *:80>" > /etc/apache2/sites-available/webmail
echo " ServerAdmin webmaster@example.org" >> /etc/apache2/sites-available/webmail
echo " DocumentRoot /var/www/roundcube" >> /etc/apache2/sites-available/webmail
echo " ServerName webmail.example.org" >> /etc/apache2/sites-available/webmail
echo " ErrorLog /var/log/apache2/webmail.error.log" >> /etc/apache2/sites-available/webmail
echo " CustomLog /var/log/apache2/webmail.access.log common" >> /etc/apache2/sites-available/webmail
echo "</VirtualHost>" >> /etc/apache2/sites-available/webmail

a2ensite webmail
service apache2 reload