#!/bin/bash
# This script creates a new user

# check if this script runs as root
if ! [ $(id -u) = 0 ]; then
  echo "You have to run this script as root user."
  exit 1
fi

user=$1
name=$2
lastname=$3

echo "User: $user"
echo "Name: $name"

if [ ! $# -ge 1 ];
then
printf "No arguments given."
exit 2;
fi

# load config file
. "./piserver.cfg"

# create user
useradd -m $user

su $user -c echo "creating user home"

uidNumber=$(id -u $user)
gidNumber=$(id -g $user)

echo "dn: cn=${user},ou=groups,${ldapdc}" > create_user.ldif
echo "cn: ${user}" >> create_user.ldif
echo "gidNumber: ${gidNumber}" >> create_user.ldif
echo "objectClass: top" >> create_user.ldif
echo "objectClass: posixGroup" >> create_user.ldif
echo "" >> create_user.ldif
echo "dn: uid=${user},ou=people,${ldapdc}" >> create_user.ldif
echo "uid: ${user}" >> create_user.ldif
echo "sn: ${lastname}" >> create_user.ldif
echo "cn: ${name} ${lastname}" >> create_user.ldif
echo "displayName: ${name}" >> create_user.ldif
echo "uidNumber: ${uidNumber}" >> create_user.ldif
echo "gidNumber: ${gidNumber}" >> create_user.ldif
echo "objectClass: top" >> create_user.ldif
echo "objectClass: person" >> create_user.ldif
echo "objectClass: inetOrgPerson" >> create_user.ldif
echo "objectClass: posixAccount" >> create_user.ldif
echo "objectClass: shadowAccount" >> create_user.ldif
echo "loginShell: /bin/bash" >> create_user.ldif
echo "homeDirectory: /home/${user}" >> create_user.ldif

ldapadd -c -x -D cn=admin,${ldapdc} -W -f create_user.ldif

rm -rf create_user.ldif

userdatadir=${piserverfolder}data/${user}
mkdir -p $userdatadir

echo "Homedir: /home/${user}"
echo "Userdatadir: $userdatadir"

chown $uidNumber $userdatadir
chgrp $gidNumber $userdatadir

# prepare btsync folder
mkdir -p /home/${user}/.btsync
cp btsync_config.json /home/${user}/.btsync/config.json

ln -s $userdatadir /home/${user}/data 

chown -R $uidNumber /home/${user}/data 
chgrp -R $gidNumber /home/${user}/data 

chown -R $uidNumber /home/${user}
chgrp -R $gidNumber /home/${user}
chmod -R 0700 /home/$user 
chmod -R 0700 $userdatadir

chown -R $uidNumber $userdatadir
chgrp -R $gidNumber $userdatadir