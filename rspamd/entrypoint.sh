#!/bin/bash

#Konfiguration redis-server
sed -i -- 's/bind 127.0.0.1/#bind 127.0.0.1/g' /etc/redis/redis.conf
sed -i -- "s/# maxmemory <bytes>/maxmemory $MAX_MEMORY/g" /etc/redis/redis.conf

#Konfigurieren von rspamd
DNS_GLOBAL=$DNS_GLOBAL envsubst < /tmp/template/rspamd/options.inc.tmpl > /etc/rspamd/local.d/options.inc
cp /tmp/template/rspamd/worker-normal.inc  /etc/rspamd/local.d/worker-normal.inc
WEB_PASSWORD=$(rspamadm pw -p $WEB_PASSWORD) envsubst < /tmp/template/rspamd/worker-controller.inc.tmpl > /etc/rspamd/local.d/worker-controller.inc
WEB_PASSWORD=$(rspamadm pw -p $WEB_PASSWORD) envsubst < /tmp/template/rspamd/worker-controller.inc.tmpl > /etc/rspamd/local.d/worker-controller.inc
REJECT_VALUE=$REJECT_VALUE ADD_HEADER_VALUE=$ADD_HEADER_VALUE GREYLIST_VALUE=$GREYLIST_VALUE envsubst < /tmp/template/rspamd/metrics.conf.tmpl > /etc/rspamd/local.d/metrics.conf

cp /tmp/template/rspamd/worker-proxy.inc  /etc/rspamd/local.d/worker-proxy.inc
cp /tmp/template/rspamd/logging.inc  /etc/rspamd/local.d/logging.inc
cp /tmp/template/rspamd/milter_headers.conf  /etc/rspamd/local.d/milter_headers.conf
cp /tmp/template/rspamd/redis.conf  /etc/rspamd/local.d/redis.conf
cp /tmp/template/rspamd/classifier-bayes.conf  /etc/rspamd/local.d/classifier-bayes.conf
cp /tmp/template/rspamd/phishing.conf  /etc/rspamd/local.d/phishing.conf
cp /tmp/template/rspamd/url_reputation.conf  /etc/rspamd/local.d/url_reputation.conf


#Starten der Dienste
echo "Services werden gestartet"
service redis-server start
service rspamd start

tail -f /var/log/rspamd/rspamd.log


