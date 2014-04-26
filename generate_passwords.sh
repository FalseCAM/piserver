#!/bin/sh
# This script generates some random passwords and saves them to the passwords.cfg file.
# Do not forget to delete the passwords.cfg file afterwards.

# Install gpw if command does not exist
type -P gpw &>/dev/null || { apt-get install gpw }

pwfile="passwords.cfg"
echo generating passwords and writing them to $pwfile


ldap_admin=$(gpw 1 12)


echo "pw_ldap_admin=$ldap_admin" > $pwfile