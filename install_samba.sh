#!/bin/bash
# This script installs samba server

# load config file
. "./piserver.cfg"
#load ldap admin password
. "./passwords.cfg"

tput setaf 2 && echo 'install samba server' && tput setaf 7


apt-get install samba samba-common-bin smbldap-tools samba-doc

# install samba schema
zcat /usr/share/doc/samba-doc/examples/LDAP/samba.schema.gz > /etc/ldap/schema/samba.schema

# create samba ldif from samba config
mkdir /tmp/slapd.d
slaptest -f ldap/samba.conf -F /tmp/slapd.d/

cp "/tmp/slapd.d/cn=config/cn=schema/cn={4}samba.ldif" "/etc/ldap/slapd.d/cn=config/cn=schema"
chown openldap: '/etc/ldap/slapd.d/cn=config/cn=schema/cn={4}samba.ldif'
/etc/init.d/slapd stop
/etc/init.d/slapd start

# change samba config

echo "passdb backend = ldapsam:ldap://localhost" >> /etc/samba/smb.conf
echo "ldap suffix = ${ldapdc}" >> /etc/samba/smb.conf
echo "ldap admin dn = cn=admin,${ldapdc}" >> /etc/samba/smb.conf
echo "ldap ssl = no" >> /etc/samba/smb.conf
echo "ldap passwd sync = Yes" >> /etc/samba/smb.conf
echo "ldap machine suffix     = ou=computers" >> /etc/samba/smb.conf
echo "ldap group suffix       = ou=groups" >> /etc/samba/smb.conf
echo "ldap user suffix        = ou=people" >> /etc/samba/smb.conf

restart smbd

smbpasswd -w $pw_ldap_admin

