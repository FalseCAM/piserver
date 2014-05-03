#!/bin/bash
# This script installs apache and php

tput setaf 2 && echo 'install apache web server' && tput setaf 7

apt-get install apache2 php5 libapache2-mod-php5


# install opcode accelerator for php
apt-get install php-apc