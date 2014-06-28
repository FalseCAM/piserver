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
sed -i "s/ passdb backend = tdbsam/ # passdb backend = tdbsam/" /etc/samba/smb.conf

sed -i "s/workgroup = WORKGROUP/workgroup = WORKGROUP\n ;option LDAP\n passdb backend = ldapsam:ldap:\/\/localhost\n ldap suffix = ${ldapdc}\n ldap admin dn = cn=admin,${ldapdc}\n ldap ssl = no\n ldap passwd sync = Yes\n ldap machine suffix     = ou=computers\n ldap group suffix       = ou=groups\n ldap user suffix        = ou=people\n/g" /etc/samba/smb.conf

sudo /etc/init.d/samba restart

smbpasswd -w $pw_ldap_admin

