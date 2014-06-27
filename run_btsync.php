<?php
$connection = ldap_connect('ldap://localhost');
ldap_set_option($connection, LDAP_OPT_PROTOCOL_VERSION, 3);
$ldapBind = ldap_bind($connection,"cn=admin,dc=example,dc=org",'password');
if (!$ldapBind)
{
  die('Connection error.');
}

$search = ldap_search($connection, 'cn=btsync_user,ou=groups,dc=example,dc=org', "(memberUid=*)",array('memberUid'));
$results = ldap_get_entries($connection, $search);


$daemon="/usr/bin/btsync";


for ($item = 0; $item < $results['count']; $item++)
{
  for ($attribute = 0; $attribute < $results[$item]['count']; $attribute++)
  {
   $data = $results[$item][$attribute];
   $btsuser = "".$results[$item][$data][0]."";
   $homedir = "";
   exec("getent passwd ".$btsuser." | cut -d: -f6", $homedir, $return_var);
   exec("pgrep -u ".$btsuser." btsync", $pid, $return_var);
   $btsync_config="".$homedir[0]."/.btsync/config.json";
   exec("start-stop-daemon -o -c ".$btsuser." -K -u ".$btsuser." -x $daemon");
   exec("start-stop-daemon -b -o -c ".$btsuser." -S -u ".$btsuser." -x ".$daemon." -- --config ".$btsync_config);
  }
}
?>  
