#!/bin/sh
# This script installs bittorrent sync

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