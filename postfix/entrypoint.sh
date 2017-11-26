#!/bin/bash

#Erstellen der Domänenabhängigen Konfigurationen
if [ ! -z $DOMAIN_1 ] && [ ! -z $KOPANO_HOST_1 ]; then
        echo $DOMAIN_1 "lmtp:["${KOPANO_HOST_1}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_1 registriert"
fi
if [ ! -z $DOMAIN_2 ] && [ ! -z $KOPANO_HOST_2 ]; then
        echo $DOMAIN_2 "lmtp:["${KOPANO_HOST_2}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_2 registriert"
fi
if [ ! -z $DOMAIN_3 ] && [ ! -z $KOPANO_HOST_3 ]; then
        echo $DOMAIN_3 "lmtp:["${KOPANO_HOST_3}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_3 registriert"
fi
if [ ! -z $DOMAIN_4 ] && [ ! -z $KOPANO_HOST_4 ]; then
        echo $DOMAIN_4 "lmtp:["${KOPANO_HOST_4}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_4 registriert"
fi
if [ ! -z $DOMAIN_5 ] && [ ! -z $KOPANO_HOST_5 ]; then
        echo $DOMAIN_5 "lmtp:["${KOPANO_HOST_5}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_5 registriert"
fi
if [ ! -z $DOMAIN_6 ] && [ ! -z $KOPANO_HOST_6 ]; then
        echo $DOMAIN_6 "lmtp:["${KOPANO_HOST_6}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_6 registriert"
fi
if [ ! -z $DOMAIN_7 ] && [ ! -z $KOPANO_HOST_7 ]; then
        echo $DOMAIN_7 "lmtp:["${KOPANO_HOST_7}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_7 registriert"
fi
if [ ! -z $DOMAIN_8 ] && [ ! -z $KOPANO_HOST_8 ]; then
        echo $DOMAIN_8 "lmtp:["${KOPANO_HOST_8}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_8 registriert"
fi
if [ ! -z $DOMAIN_9 ] && [ ! -z $KOPANO_HOST_9 ]; then
        echo $DOMAIN_9 "lmtp:["${KOPANO_HOST_9}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_9 registriert"
fi

postmap /etc/postfix/transport
usermod -a -G sasl postfix

#Anpassen der Postfix Config und der Aliase
DB_HOST=$DB_HOST DB_USER=$DB_USER DB_PASS=$DB_PASS DB_NAME=$DB_NAME envsubst < /tmp/template/postfix/mysql-virtual-alias-maps.cf.tmpl > /etc/postfix/mysql-virtual-alias-maps.cf
DOMAIN_1=$DOMAIN_1 SPAMCHECK_CONTAINER=$SPAMCHECK_CONTAINER SPAMCHECK_PORT=$SPAMCHECK_PORT ENCRYPT_SETTING=$ENCRYPT_SETTING envsubst < /tmp/template/postfix/main.cf.tmpl > /etc/postfix/main.cf


#Starten des Sasl Dienstes
service rsyslog start
cp /tmp/template/saslauthd/smtpd.conf /etc/postfix/sasl/smtpd.conf
mkdir -p /var/spool/postfix/var/run/saslauthd
rm -rf /run/saslauthd
ln -s /var/spool/postfix/var/run/saslauthd   /run/saslauthd
saslauthd -a rimap -O "$IMAPPROXY_HOST" -V -r -m /var/spool/postfix/var/run/saslauthd


#Starten von Postfix
service postfix start
postfix reload


tail -f /var/log/mail.*

