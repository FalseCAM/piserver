#!/bin/bash
# This script installs owncloud

tput setaf 2 && echo 'install owncloud' && tput setaf 7

# load config file
. "./piserver.cfg"

# Install wget if not exists
if ! type wget > /dev/null; then
  sudo apt-get install wget
fi

# install needed packages
apt-get install apache2 php5 php5-common php5-intl php5-cli php5-ldap php-apc
# install mysql
apt-get install mysql-client mysql-server php5-mysql
#
apt-get install curl libcurl3 libcurl4-openssl-dev ffmpeg
apt-get install php5-gd php5-json php5-curl
apt-get install php5-intl php5-mcrypt php5-imagick



# download owncloud package
wget https://download.owncloud.org/community/owncloud-7.0.0.tar.bz2
# extract owncloud
tar -xjf owncloud-7.0.0.tar.bz2

# copy owncloud to /var/www/
mv owncloud /var/www/
# change owner of files
chown -R www-data:www-data /var/www/

#enable apache modules
a2enmod rewrite
a2enmod ssl


#create owncloud apache config
'<IfModule mod_ssl.c>' > /etc/apache2/sites-available/owncloud
'<VirtualHost _default_:443>' >> /etc/apache2/sites-available/owncloud
'        ServerName owncloud.${hostname}' >> /etc/apache2/sites-available/owncloud
'        ServerAdmin webmaster@localhost' >> /etc/apache2/sites-available/owncloud
'        DocumentRoot /var/www' >> /etc/apache2/sites-available/owncloud
'       <Directory />' >> /etc/apache2/sites-available/owncloud
'                Options FollowSymLinks' >> /etc/apache2/sites-available/owncloud
'                AllowOverride None' >> /etc/apache2/sites-available/owncloud
'        </Directory>' >> /etc/apache2/sites-available/owncloud
'        <Directory /var/www/>' >> /etc/apache2/sites-available/owncloud
'                Options Indexes FollowSymLinks MultiViews' >> /etc/apache2/sites-available/owncloud
'                AllowOverride None' >> /etc/apache2/sites-available/owncloud
'                Order allow,deny' >> /etc/apache2/sites-available/owncloud
'                allow from all' >> /etc/apache2/sites-available/owncloud
'        </Directory>' >> /etc/apache2/sites-available/owncloud
'        ErrorLog ${APACHE_LOG_DIR}/error.log' >> /etc/apache2/sites-available/owncloud
'        LogLevel warn' >> /etc/apache2/sites-available/owncloud
'        CustomLog ${APACHE_LOG_DIR}/ssl_access.log combined' >> /etc/apache2/sites-available/owncloud
'        SSLEngine on' >> /etc/apache2/sites-available/owncloud
'        SSLCertificateFile    /etc/ssl/certs/piserver.crt' >> /etc/apache2/sites-available/owncloud
'        SSLCertificateKeyFile /etc/ssl/private/piserver.key' >> /etc/apache2/sites-available/owncloud
'        <FilesMatch "\.(cgi|shtml|phtml|php)$">' >> /etc/apache2/sites-available/owncloud
'                SSLOptions +StdEnvVars' >> /etc/apache2/sites-available/owncloud
'        </FilesMatch>' >> /etc/apache2/sites-available/owncloud
'        <Directory /usr/lib/cgi-bin>' >> /etc/apache2/sites-available/owncloud
'                SSLOptions +StdEnvVars' >> /etc/apache2/sites-available/owncloud
'        </Directory>' >> /etc/apache2/sites-available/owncloud
'        BrowserMatch "MSIE [2-6]" \\' >> /etc/apache2/sites-available/owncloud
'                nokeepalive ssl-unclean-shutdown \\' >> /etc/apache2/sites-available/owncloud
'                downgrade-1.0 force-response-1.0' >> /etc/apache2/sites-available/owncloud
'        BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown' >> /etc/apache2/sites-available/owncloud
'        <Directory /var/www/owncloud>' >> /etc/apache2/sites-available/owncloud
'                Options Indexes FollowSymLinks MultiViews' >> /etc/apache2/sites-available/owncloud
'                AllowOverride All' >> /etc/apache2/sites-available/owncloud
'                Order allow,deny' >> /etc/apache2/sites-available/owncloud
'                Allow from all' >> /etc/apache2/sites-available/owncloud
'				 Dav Off' >> /etc/apache2/sites-available/owncloud
'                Satisfy Any' >> /etc/apache2/sites-available/owncloud
'        </Directory>' >> /etc/apache2/sites-available/owncloud
'</VirtualHost>' >> /etc/apache2/sites-available/owncloud
'</IfModule>' >> /etc/apache2/sites-available/owncloud

#restart apache
a2ensite owncloud
service apache2 restart