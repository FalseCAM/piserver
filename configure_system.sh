#!/bin/bash
# configure the system

# load config file
. "./piserver.cfg"

tput setaf 2 && echo 'configure the system' && tput setaf 7


# first configure your raspbian
raspi-config

# remove unused x files
apt-get remove gnome*
apt-get remove x11-common*
apt-get autoremove


# update your system
apt-get update && apt-get upgrade

# add ipv6 support to kernel
modprobe ipv6
echo "ipv6" >> /etc/modules

# configure hostname
echo "${servername}" > /etc/hostname
sed -i "s/127.0.1.1.*$/127.0.1.1\t${servername}/g" /etc/hosts

# create user for www-data
groupadd www-data
usermod -a -G www-data www-data

# create piserver data directory
mkdir -p $piserverfolder


# uncomment following to prepare an external hdd on /dev/sda
# umount /dev/sda1
# mkfs.ext4 /dev/sda1 -L PISERVERDATA
# sudo su -c "echo 'LABEL=PISERVERDATA  $piserverfolder  ext4  defaults 0 2' >> /etc/fstab"
# mount -a
# chmod 1777 $piserverfolder