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
echo '<IfModule mod_ssl.c>' > /etc/apache2/sites-available/owncloud
echo '<VirtualHost _default_:443>' >> /etc/apache2/sites-available/owncloud
echo '        ServerName owncloud.${hostname}' >> /etc/apache2/sites-available/owncloud
echo '        ServerAdmin webmaster@localhost' >> /etc/apache2/sites-available/owncloud
echo '        DocumentRoot /var/www/owncloud' >> /etc/apache2/sites-available/owncloud
echo '       <Directory />' >> /etc/apache2/sites-available/owncloud
echo '                Options FollowSymLinks' >> /etc/apache2/sites-available/owncloud
echo '                AllowOverride None' >> /etc/apache2/sites-available/owncloud
echo '        </Directory>' >> /etc/apache2/sites-available/owncloud
echo '        ErrorLog ${APACHE_LOG_DIR}/error.log' >> /etc/apache2/sites-available/owncloud
echo '        LogLevel warn' >> /etc/apache2/sites-available/owncloud
echo '        CustomLog ${APACHE_LOG_DIR}/ssl_access.log combined' >> /etc/apache2/sites-available/owncloud
echo '        SSLEngine on' >> /etc/apache2/sites-available/owncloud
echo '        SSLCertificateFile    /etc/ssl/certs/piserver.crt' >> /etc/apache2/sites-available/owncloud
echo '        SSLCertificateKeyFile /etc/ssl/private/piserver.key' >> /etc/apache2/sites-available/owncloud
echo '        <FilesMatch "\.(cgi|shtml|phtml|php)$">' >> /etc/apache2/sites-available/owncloud
echo '                SSLOptions +StdEnvVars' >> /etc/apache2/sites-available/owncloud
echo '        </FilesMatch>' >> /etc/apache2/sites-available/owncloud
echo '        <Directory /usr/lib/cgi-bin>' >> /etc/apache2/sites-available/owncloud
echo '                SSLOptions +StdEnvVars' >> /etc/apache2/sites-available/owncloud
echo '        </Directory>' >> /etc/apache2/sites-available/owncloud
echo '        BrowserMatch "MSIE [2-6]" \\' >> /etc/apache2/sites-available/owncloud
echo '                nokeepalive ssl-unclean-shutdown \\' >> /etc/apache2/sites-available/owncloud
echo '                downgrade-1.0 force-response-1.0' >> /etc/apache2/sites-available/owncloud
echo '        BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown' >> /etc/apache2/sites-available/owncloud
echo '        <Directory /var/www/owncloud>' >> /etc/apache2/sites-available/owncloud
echo '                Options Indexes FollowSymLinks MultiViews' >> /etc/apache2/sites-available/owncloud
echo '                AllowOverride All' >> /etc/apache2/sites-available/owncloud
echo '                Order allow,deny' >> /etc/apache2/sites-available/owncloud
echo '                Allow from all' >> /etc/apache2/sites-available/owncloud
echo '				 Dav Off' >> /etc/apache2/sites-available/owncloud
echo '                Satisfy Any' >> /etc/apache2/sites-available/owncloud
echo '        </Directory>' >> /etc/apache2/sites-available/owncloud
echo '</VirtualHost>' >> /etc/apache2/sites-available/owncloud
echo '</IfModule>' >> /etc/apache2/sites-available/owncloud

#restart apache
a2ensite owncloud
service apache2 restart