#!/bin/bash
# This script installs postfix

# load config file
. "./piserver.cfg"
#load ldap admin password
. "./passwords.cfg"

tput setaf 2 && echo 'install postfix' && tput setaf 7

sudo apt-get install postfix

echo "home_mailbox = Maildir/" >> /etc/postfix/main.cf
echo "mailbox_command =" >> /etc/postfix/main.cf

sudo apt-get install dovecot-common dovecot-imapd

# create skel
sudo maildirmake.dovecot /etc/skel/Maildir
sudo maildirmake.dovecot /etc/skel/Maildir/.Drafts
sudo maildirmake.dovecot /etc/skel/Maildir/.Sent
sudo maildirmake.dovecot /etc/skel/Maildir/.Spam
sudo maildirmake.dovecot /etc/skel/Maildir/.Trash
sudo maildirmake.dovecot /etc/skel/Maildir/.Templates

echo "smtpd_recipient_restrictions = permit_sasl_authenticated,
			permit_mynetworks,
			reject_unauth_destination" >> /etc/postfix/main.cf

echo "smtpd_helo_required = yes" >> /etc/postfix/main.cf
echo "smtpd_helo_restrictions =
        permit_mynetworks,
        permit_sasl_authenticated,
        reject_invalid_helo_hostname,
        reject_non_fqdn_helo_hostname,
        reject_unknown_helo_hostname" >> /etc/postfix/main.cf
