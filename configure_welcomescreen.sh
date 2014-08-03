#!/bin/bash
# This script configures pi's welcome screen
# source: http://0fury.de/raspberry-pi-willkommensbildschirm-fuer-die-konsole/

# load config file
. "./piserver.cfg"

tput setaf 2 && echo 'configure console welcome screen' && tput setaf 7

# Install figlet
  sudo apt-get install figlet
  
echo 'figlet "PiServer \"$(hostname)\""' >> /home/pi/.bash_profile
echo "systemup=\$(uptime | awk -F ', lo' '{print \$1}' )" >> /home/pi/.bash_profile
echo 'echo \"Uptime:$systemup\"' >> /home/pi/.bash_profile
echo "temperature=\$(/opt/vc/bin/vcgencmd measure_temp | awk -F 'temp=' '{print \$NF}' | awk -F \"'C\" '{print \$1}')" >> /home/pi/.bash_profile
echo 'echo \"Temperature: \$temperature C\"' >> /home/pi/.bash_profile
echo 'free -h' >> /home/pi/.bash_profile
echo "df -h $piserverfolder" >> /home/pi/.bash_profile

chown pi /home/pi/.bash_profile
chgrp pi /home/pi/.bash_profile