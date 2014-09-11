#!/bin/bash
# This script installs openvpn
# a virtual private net with ldap as user auth.

# load config file
. "./piserver.cfg"
#load ldap admin password
. "./passwords.cfg"

tput setaf 2 && echo 'install openvpn' && tput setaf 7

sudo apt-get install openvpn openssl openvpn-auth-ldap
cp -r /usr/share/doc/openvpn/examples/easy-rsa/2.0 /etc/openvpn/easy-rsa
/etc/openvpn/easy-rsa/clean-all
ln -s /etc/openvpn/easy-rsa/openssl-1.0.0.cnf /etc/openvpn/easy-rsa/openssl.cnf
/etc/openvpn/easy-rsa/build-ca piserver-vpn
cp /etc/openvpn/easy-rsa/keys/ca.crt /etc/openvpn/easy-rsa/keys/piserver-vpn-ca.crt
/usr/sbin/openvpn --genkey --secret /etc/openvpn/easy-rsa/keys/piserver-vpn-ca.key
/etc/openvpn/easy-rsa/build-key-server piserver-vpn-server
/etc/openvpn/easy-rsa/build-dh


mkdir /etc/openvpn/auth
cp /usr/share/doc/openvpn-auth-ldap/examples/auth-ldap.conf /etc/openvpn/auth

vim /etc/openvpn/auth/auth-ldap.conf

vim /etc/openvpn/openvpn.conf
