#!/bin/sh
# configure the system

tput setaf 2 && echo 'configure the system' && tput setaf 7

# add ipv6 support to kernel
modprobe ipv6
echo "ipv6" >> /etc/modules

# create user for www-data
groupadd www-data
usermod -a -G www-data www-data 