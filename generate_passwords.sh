#!/bin/bash
# This script generates some random passwords and saves them to the passwords.cfg file.
# Do not forget to delete the passwords.cfg file afterwards.

tput setaf 2 && echo 'generate some passwords' && tput setaf 7

# Install gpw if command does not exist
if ! type gpw > /dev/null; then
  sudo apt-get install gpw
fi

pwfile="passwords.cfg"
echo generating passwords and writing them to $pwfile

piserver_admin=$(gpw 1 12)
ldap_admin=$(gpw 1 12)
mysql_admin=$(gpw 1 12)


echo "pw_piserver_admin=$piserver_admin" > $pwfile
echo "pw_ldap_admin=$ldap_admin" >> $pwfile
echo "pw_mysql_admin=$mysql_admin" >> $pwfile