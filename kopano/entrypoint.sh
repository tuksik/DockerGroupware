#!/bin/bash

####Anpassen der Kopano Config
sed -i "s/define(\"THEME\", '');/define(\"THEME\", '$DEFAULT_THEME');/g" /etc/kopano/webapp/config.php

#/etc/kopano/server.cfg
sed -i "s/system_email_address.*/system_email_address = $KOPANO_SYSTEM_EMAIL/g" /etc/kopano/server.cfg
sed -i "s/^#log_level.*/log_level = $KOPANO_SERVER_LOGLEVEL/g" /etc/kopano/server.cfg
sed -i "s/^mysql_host.*/mysql_host = $DB_HOST/g" /etc/kopano/server.cfg
sed -i "s/^mysql_user.*/mysql_user = $DB_USER/g" /etc/kopano/server.cfg
sed -i "s/^mysql_password.*/mysql_password = $DB_PASS/g" /etc/kopano/server.cfg
sed -i "s/^mysql_database.*/mysql_database = $DB_NAME/g" /etc/kopano/server.cfg
sed -i "s/^attachment_storage.*/attachment_storage = $KOPANO_ATTACHMENT_STORAGE/g" /etc/kopano/server.cfg
sed -i "s/^disabled_features.*/disabled_features =pop3/g" /etc/kopano/server.cfg
#/etc/kopano/gateway.cfg
sed -i "s/^server_hostname .*/server_hostname = $DOMAIN/g" /etc/kopano/gateway.cfg
sed -i "s/^pop3_enable .*/pop3_enable = no/g" /etc/kopano/gateway.cfg
sed -i "s/^server_hostname .*/server_hostname = $DOMAIN/g" /etc/kopano/gateway.cfg
sed -i "s/^#log_level.*/log_level = $KOPANO_SERVER_LOGLEVEL/g" /etc/kopano/gateway.cfg
#/etc/spooler/dagent.cfg
sed -i "s/^#log_level.*/log_level = $KOPANO_SERVER_LOGLEVEL/g" /etc/kopano/dagent.cfg
sed -i "s/^spam_header_name .*/spam_header_name = $SPAM_HEADER/g" /etc/kopano/dagent.cfg
sed -i "s/^spam_header_value .*/spam_header_value = $SPAM_VALUE/g" /etc/kopano/dagent.cfg
#/etc/spooler/spooler.cfg
sed -i "s/^#log_level.*/log_level = $KOPANO_SERVER_LOGLEVEL/g" /etc/kopano/spooler.cfg
sed -i "s/^smtp_server.*/smtp_server = $SMTP_SERVER/g" /etc/kopano/spooler.cfg


cp /tmp/template/kopano/20-kopano.ini /etc/php/7.0/fpm/conf.d/20-kopano.ini

#Kopieren von Kopano Serice Start Skripten
if [ ! -f "/etc/init.d/kopano-server"  ]; then
    cp /tmp/template/services/* /etc/init.d/ 
	chmod 777 /etc/init.d/kopano-*
	echo "Startscripts created"
fi


#Anpassen der Nginx Config
cp /tmp/template/nginx/nginx.conf /etc/nginx/nginx.conf
sed -i "s/server_name .*/ server_name $DOMAIN;/g" /etc/nginx/nginx.conf

###Anpassen der z-Push config
chown -R www-data:www-data /var/lib/z-push
chown -R www-data:www-data /var/log/z-push
#/etc/z-push/z-push.conf.php
sed -i "s/('TIMEZONE', '')/('TIMEZONE', '$TIMEZONE');/g" /etc/z-push/z-push.conf.php
sed -i "s/('STATE_MACHINE'.*/('STATE_MACHINE', 'SQL');/g" /etc/z-push/z-push.conf.php
#/etc/z-push/state-sql.conf.php
sed -i "s/('STATE_SQL_SERVER'.*/('STATE_SQL_SERVER', '$DB_HOST');/g" /etc/z-push/state-sql.conf.php 
sed -i "s/('STATE_SQL_DATABASE'.*/('STATE_SQL_DATABASE', '$DB_NAME_ZPUSH');/g" /etc/z-push/state-sql.conf.php 
sed -i "s/('STATE_SQL_USER'.*/('STATE_SQL_USER', '$DB_USER');/g" /etc/z-push/state-sql.conf.php 
sed -i "s/('STATE_SQL_PASSWORD'.*/('STATE_SQL_PASSWORD', '$DB_PASS');/g" /etc/z-push/state-sql.conf.php 

# Anpassen der php.ini für z-push
echo "php_flag magic_quotes_gpc = off" >> /etc/php/7.0/fpm/php.ini
echo "php_flag register_globals = off" >> /etc/php/7.0/fpm/php.ini
echo "php_flag magic_quotes_runtime = off" >> /etc/php/7.0/fpm/php.ini
echo "php_flag short_open_tag = on" >> /etc/php/7.0/fpm/php.ini

#Anpassen der PHP-FPM Config
sed -i  "s/post_max_size =.*/post_max_size = $PHP_POST_MAX_SIZE/g"  /etc/php/7.0/fpm/php.ini
sed -i  "s/upload_max_filesize =.*/upload_max_filesize = $PHP_UPLOAD_MAX_FILESIZE/g"  /etc/php/7.0/fpm/php.ini
sed -i  "s/memory_limit = .*/memory_limit = $PHP_MEMORY_LIMIT/g"  /etc/php/7.0/fpm/php.ini

sed -i "s/;pm.status_path = \/status/pm.status_path = \/status/g" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "s/pm.max_children.*/pm.max_children = $FPM_MAX_CHILDREN/g" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "s/pm.start_servers.*/pm.start_servers = 5/g" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "s/pm.min_spare_servers.*/pm.min_spare_servers = 5/g" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "s/pm.max_spare_servers.*/pm.max_spare_servers = 10/g" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "s/;pm.max_requests.*/pm.max_requests = 500/g" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "s/;request_slowlog_timeout.*/request_slowlog_timeout = 5s/g" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "s/;slowlog.*/slowlog = \/var\/log\/slowlog.log.slow/g" /etc/php/7.0/fpm/pool.d/www.conf

sed -i "s/;emergency_restart_threshold.*/emergency_restart_threshold = 10/g" /etc/php/7.0/fpm/php-fpm.conf
sed -i "s/;emergency_restart_interval.*/emergency_restart_interval = 1m/g" /etc/php/7.0/fpm/php-fpm.conf
sed -i "s/;process_control_timeout.*/process_control_timeout = 10/g" /etc/php/7.0/fpm/php-fpm.conf



#Starten von Nginx
service nginx start

#Starten von nginx amplify-agent
if [ ! -z "$NGINX_API_KEY" ]; then
	echo "Start Nginx Amplify"
	
	#Anpassen der Amplify Config
	sed -i "s/api_key .*/api_key = $NGINX_API_KEY/g" /etc/amplify-agent/agent.conf
	sed -i "s/hostname .*/hostname = kopano\.$DOMAIN/g" /etc/amplify-agent/agent.conf
	sed -i "s/uuid =.*/uuid = 0f2c2dcf00205d45a6eba415b862bba1/g" /etc/amplify-agent/agent.conf
	
	#Starten des Amplify Dienstes
	service amplify-agent start
else
	echo "Nginx Amplify wird nicht gestartet ... NGINX_API_KEY wurde nicht übergeben"
fi

#Starten der Services
service php7.0-fpm start
service nginx start
service kopano-server start
service rsyslog start
service kopano-dagent start
service kopano-spooler start
service kopano-gateway start
service kopano-ical start
#service kopano-monitor start
service kopano-search start


tail -f  /var/log/kopano/* /var/log/nginx/* /var/log/z-push/*
#kopano-admin -c gestl -p 12init34 -e daniel.gestl@it-yourself.at -f „Daniel Gestl“ -a1
#kopano-admin -c test@meteor-qs.de -p test -e test@meteor-qs.de -f test -a1