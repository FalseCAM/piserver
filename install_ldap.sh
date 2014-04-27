#!/bin/sh
# This script installs ldap and configures it.

# Install slapd if not exists
if ! type slapd > /dev/null; then
  sudo apt-get install slapd
fi

# Install ldap-utils if not exists
if ! type ldap-utils > /dev/null; then
  sudo apt-get install ldap-utils
fi

# reconfigure
sudo dpgk-reconfigure slapd

#install libpam and libnss with ldap backend
sudo apt-get install libpam-ldapd libnss-ldapd

# add mkhomedir to config
echo "session required pam_mkhomedir.so umask=0022 skel=/etc/skel" >> /etc/pam.d/common-session

# configure ldap index
ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f ldap/indexchange.ldif
service slapd stop
sudo -u openldap slapindex
service slapd start

# configure secure connections
sed -i 's/^SLAPD_SERVICES=.*/SLAPD_SERVICES="ldap://127.0.0.1:389/ ldaps:/// ldapi:///"' /etc/default/slapd

ldapmodify -Y EXTERNAL -H ldapi:/// -f ldap/olcSSL.ldif

# add openldap user to ssl-cert group
usermod -a -G ssl-cert openldap