#!/bin/bash
# This script installs openvpn
# a virtual private net with ldap as user auth.

# load config file
. "./piserver.cfg"
#load ldap admin password
. "./passwords.cfg"

tput setaf 2 && echo 'install openvpn' && tput setaf 7

sudo apt-get install openvpn openssl openvpn-auth-ldap dnsmasq
cp -r /usr/share/doc/openvpn/examples/easy-rsa/2.0 /etc/openvpn/easy-rsa
# prepare config file
sed -i "s/export EASY_RSA=.*/export EASY_RSA=\"/etc/openvpn/easy-rsa\"/g" "/etc/openvpn/easy-rsa/vars"

# edit vars file
vim /etc/openvpn/easy-rsa/vars
# load vars
. "/etc/openvpn/easy-rsa/vars"

/etc/openvpn/easy-rsa/clean-all
/etc/openvpn/easy-rsa/pkitool --initca
ln -s /etc/openvpn/easy-rsa/openssl-1.0.0.cnf /etc/openvpn/easy-rsa/openssl.cnf

/etc/openvpn/easy-rsa/pkitool --server server
/etc/openvpn/easy-rsa/build-dh

# copy keys
cp /etc/openvpn/easy-rsa/keys/{ca.crt,ca.key,server.crt,server.key,dh1024.pem} /etc/openvpn/ 

# unzip server config
gunzip -d /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz
mv /usr/share/doc/openvpn/examples/sample-config-files/server.conf /etc/openvpn/
echo "push \"redirect-gateway def1\"" >> /etc/openvpn/server.conf
echo "push \"dhcp-option DNS 10.8.0.1\"" >> /etc/openvpn/server.conf
echo "plugin /usr/lib/openvpn/openvpn-auth-ldap.so /etc/openvpn/auth/auth-ldap.conf" >> /etc/openvpn/server.conf
echo "client-cert-not-required" >> /etc/openvpn/server.conf
echo "log    /var/log/openvpn.log" >> /etc/openvpn/server.conf

mkdir /etc/openvpn/auth
cp /usr/share/doc/openvpn-auth-ldap/examples/auth-ldap.conf /etc/openvpn/auth
vim /etc/openvpn/auth/auth-ldap.conf

# create log file
touch /var/log/openvpn.log
chown nobody.nogroup /var/log/openvpn.log
sed -i "s/log.*/log	\"/var/log/openvpn.log\"/g" "/etc/openvpn/server.conf"

# prepare internet forwarding
sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" "/etc/sysctl.conf"
sysctl -p

# change eth0 with your network adapter
(crontab -l 2>/dev/null; echo "@reboot sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j SNAT --to-source ${piserverip}")| crontab - 

/etc/init.d/openvpn restart

# prepare client config
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/client.ovpn
sed -i "s/cert client.crt/#cert client.crt/g" "/etc/openvpn/client.ovpn"
sed -i "s/key client.key/#key client.key/g" "/etc/openvpn/client.ovpn"
echo "auth-user-pass" >> /etc/openvpn/client.ovpn