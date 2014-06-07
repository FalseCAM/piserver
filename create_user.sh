#!/bin/bash
# This script creates a new user

# check if this script runs as root
if ! [ $(id -u) = 0 ]; then
  echo "You have to run this script as root user."
  exit 1
fi

user = $1
name = $2

if id -u $user >/dev/null 2>&1; then
        exit 1
else
        echo "creating user $user"
fi

# load config file
. "./piserver.cfg"

# create user
useradd -m $user
uidNumber = id -u $user
gidNumber = id -g $user

echo "dn: uid=${user},ou=people,${ldapdc}" > create_user.ldif
echo "objectClass: inetOrgPerson" >> create_user.ldif
echo "objectClass: posixAccount" >> create_user.ldif
echo "objectClass: shadowAccount" >> create_user.ldif
echo "uid: ${user}" >> create_user.ldif
echo "displayName: ${name}" >> create_user.ldif
echo "uidNumber: ${uidNumber}" >> create_user.ldif
echo "gidNumber: ${gidNumber}" >> create_user.ldif
echo "loginShell: /bin/bash" >> create_user.ldif
echo "homeDirectory: /home/${uid}" >> create_user.ldif

ldapadd -Y EXTERNAL -H ldapi:/// -f create_user.ldif
rm -rf create_user.ldif

userdatadir = ${piserverfolder}data/${user}
mkdir -p $userdatadir

chown uidNumber $userdatadir
chgrp gidNumber $userdatadir

ln -s $userdatadir /home/${uid}/data 

chown uidNumber /home/${uid}/data 
chgrp gidNumber /home/${uid}/data 