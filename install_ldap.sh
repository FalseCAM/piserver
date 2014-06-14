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
dpkg-reconfigure slapd

#install libpam and libnss with ldap backend
apt-get install libpam-ldapd libnss-ldapd

# add mkhomedir to config
echo "session required pam_mkhomedir.so umask=0022 skel=/etc/skel" >> /etc/pam.d/common-session
service slapd start
# configure ldap index
ldapmodify -Y EXTERNAL -H ldapi:/// -f ldap/indexchanges.ldif
service slapd stop
sudo -u openldap slapindex
echo "creating directory tree"
# create directory tree
sed -i "s/dc=example,dc=org/${ldapdc}/g" "ldap/directorytree.ldif"
slapadd -c -v -l ldap/directorytree.ldif
echo "adding groups"
# create group
sed -i "s/dc=example,dc=org/${ldapdc}/g" "ldap/groups.ldif"
slapadd -c -v -l ldap/groups.ldif
chown -R openldap:openldap /var/lib/ldap
service slapd start

# install ldap-account-manager, a web based ldap config tool
tput setaf 2 && echo 'install ldap-account-manager, a web based ldap config tool' && tput setaf 7
apt-get install ldap-account-manager

#install tls certificate
sh install_ldap_tls.sh