#!/bin/bash
# This script installs ldap and configures it.

# Install slapd if not exists
if ! type slapd > /dev/null; then
  apt-get install slapd
fi

# Install ldap-utils if not exists
if ! type ldap-utils > /dev/null; then
  apt-get install ldap-utils
fi

# load config file
. "./piserver.cfg"

tput setaf 2 && echo 'install ldap' && tput setaf 7

# reconfigure
dpgk-reconfigure slapd

#install libpam and libnss with ldap backend
apt-get install libpam-ldapd libnss-ldapd

# add mkhomedir to config
echo "session required pam_mkhomedir.so umask=0022 skel=/etc/skel" >> /etc/pam.d/common-session

# configure ldap index
ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f ldap/indexchanges.ldif
service slapd stop
sudo -u openldap slapindex

# configure secure connections
sed -i 's/^SLAPD_SERVICES=.*/SLAPD_SERVICES="ldap:\/\/127.0.0.1:389\/ ldaps:\/\/\/ ldapi:\/\/\/"/g' /etc/default/slapd
ldapmodify -Y EXTERNAL -H ldapi:/// -f ldap/olcSSL.ldif

# create directory tree
sed -i 's/dc=example,dc=org/$ldapdc/g' ldap/directorytree.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f ldap/directorytree.ldif

# create group
sed -i 's/dc=example,dc=org/$ldapdc/g' ldap/groups.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f ldap/groups.ldif

service slapd start

# add openldap user to ssl-cert group
usermod -a -G ssl-cert openldap

# install ldap-account-manager, a web based ldap config tool
tput setaf 2 && echo 'install ldap-account-manager, a web based ldap config tool' && tput setaf 7
apt-get install ldap-account-manager