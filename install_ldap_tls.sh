#!/bin/bash
# This script installs ldap tls certificate.

apt-get install gnutls-bin ssl-cert

# load config file
. "./piserver.cfg"

tput setaf 2 && echo 'install ldap tls certificate' && tput setaf 7

sudo sh -c "certtool --generate-privkey > /etc/ssl/private/cakey.pem"

#create ca info file
echo "cn = $servername" > /etc/ssl/ca.info
echo "ca" >> /etc/ssl/ca.info
echo "cert_signing_key" >> /etc/ssl/ca.info

#create self-signed CA certificate
certtool --generate-self-signed --load-privkey /etc/ssl/private/cakey.pem \
 --template /etc/ssl/ca.info --outfile /etc/ssl/certs/cacert.pem
 
#create private key
certtool --generate-privkey --bits 1024 --outfile /etc/ssl/private/ldap_slapd_key.pem

#create key info file
echo "organization = $servername" > /etc/ssl/ldap_slapd.info
echo "cn = ${hostname}" > /etc/ssl/ldap_slapd.info
echo "tls_www_server" > /etc/ssl/ldap_slapd.info
echo "encryption_key" > /etc/ssl/ldap_slapd.info
echo "signing_key" > /etc/ssl/ldap_slapd.info
echo "expiration_days = 3650" > /etc/ssl/ldap_slapd.info

# create server certificate
certtool --generate-certificate --load-privkey /etc/ssl/private/ldap_slapd_key.pem \
 --load-ca-certificate /etc/ssl/certs/cacert.pem --load-ca-privkey /etc/ssl/private/cakey.pem \
 --template /etc/ssl/ldap_slapd.info --outfile /etc/ssl/certs/ldap_slapd_cert.pem
 
# modify ldap config
ldapmodify -Y EXTERNAL -H ldapi:/// -f ldap/cert.ldif

# configure secure connections
sed -i 's/^SLAPD_SERVICES=.*/SLAPD_SERVICES="ldap:\/\/\/ ldaps:\/\/\/ ldapi:\/\/\/"/g' /etc/default/slapd

#change ownership of certificates
adduser openldap ssl-cert
chgrp ssl-cert /etc/ssl/private/ldap_slapd_key.pem
chmod g+r /etc/ssl/private/ldap_slapd_key.pem
chmod o-r /etc/ssl/private/ldap_slapd_key.pem

# restart the ldap service
service slapd restart