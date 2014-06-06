#!/bin/bash
# configure the system

# load config file
. "./piserver.cfg"

tput setaf 2 && echo 'configure the system' && tput setaf 7

# add ipv6 support to kernel
modprobe ipv6
echo "ipv6" >> /etc/modules

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