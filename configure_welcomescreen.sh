#!/bin/bash
# This script configures pi's welcome screen
# source: http://0fury.de/raspberry-pi-willkommensbildschirm-fuer-die-konsole/

# load config file
. "./piserver.cfg"

tput setaf 2 && echo 'configure console welcome screen' && tput setaf 7

# Install figlet
  sudo apt-get install figlet
  
echo -e 'figlet \"PiServer \"$(hostname)\"\"' >> /home/pi/.bash_profile
echo -e 'systemup=$(uptime | awk -F \', lo\' \'{print $1}\' )' >> /home/pi/.bash_profile
echo -e 'echo \"Uptime:$systemup\"' >> /home/pi/.bash_profile
echo -e 'temperature=$(/opt/vc/bin/vcgencmd measure_temp | awk -F \'temp=\' \'{print $NF}\' | awk -F \"\'C\" \'{print $1}\')' >> /home/pi/.bash_profile
echo -e 'echo \"Temperature: $temperature C\"' >> /home/pi/.bash_profile
echo -e 'free -h' >> /home/pi/.bash_profile
echo -e "df -h $(piserverfolder)" >> /home/pi/.bash_profile

chown pi /home/pi/.bash_profile
chgrp pi /home/pi/.bash_profile