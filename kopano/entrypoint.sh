#!/bin/bash

#Anpassen der Kopano Config
DB_HOST=$DB_HOST DB_USER=$DB_USER DB_PASS=$DB_PASS DB_NAME=$DB_NAME envsubst < /tmp/template/kopano/server.cfg.tmpl > /etc/kopano/server.cfg
DOMAIN=$DOMAIN envsubst < /tmp/template/kopano/gateway.cfg.tmpl > /etc/kopano/gateway.cfg
SMTP_SERVER=$SMTP_SERVER envsubst < /tmp/template/kopano/spooler.cfg.tmpl > /etc/kopano/spooler.cfg
SPAM_HEADER=$SPAM_HEADER SPAM_VALUE=$SPAM_VALUE envsubst < /tmp/template/kopano/dagent.cfg.tmpl > /etc/kopano/dagent.cfg

#Anpassen der apache2 Config
cp /tmp/template/apache2/kopano-webapp.conf /etc/apache2/sites-available
DOMAIN=$DOMAIN envsubst < /tmp/template/apache2/apache2.conf.tmpl > /etc/apache2/apache2.conf

#Starten der Services
service kopano-server start
service apache2 start
service rsyslog start
service kopano-dagent start
service kopano-spooler start
service kopano-gateway start
service kopano-search start
service kopano-ical start
service kopano-monitor start

tail -f /var/log/kopano/*
#kopano-admin -c gestl -p 12init34 -e daniel.gestl@it-yourself.at -f „Daniel Gestl“ -a1
