#!/bin/sh

# add ipv6 support to kernel

modprobe ipv6
echo "ipv6" >> /etc/modules
