#!/bin/sh
# This script installs bittorrent sync

source piserver.cfg

tput setaf 2 && echo 'install bittorrent sync' && tput setaf 7

# Install wget if not exists
if ! type wget > /dev/null; then
  sudo apt-get install wget
fi

# download btsync package
wget http://btsync.s3-website-us-east-1.amazonaws.com/btsync_arm.tar.gz

# extract btsync
tar -xfv btsync_arm.tar.gz
mv LICENSE.txt btsync-LICENSE.txt

# move btsync to /usr/bin folder
sudo mv btsync* /usr/bin

# create data directory
mkdir -p $btsyncdatafolder

# install jq
wget http://stedolan.github.io/jq/download/source/jq-1.3.tar.gz
tar -xfv jq-1.3.tar.gz
cd jq-1.3
./configure
make
make install