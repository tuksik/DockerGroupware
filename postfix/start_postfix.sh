container=meteorit_postfix


docker stop $container 2>/dev/null
docker rm $container 2> /dev/null


docker run  -d \
	--network=meteorit_network \
	--name $container \
	-p 25:25 \
	-e DB_HOST=meteorit_database \
	-e DB_USER=postfix \
	-e DB_PASS=postfix \
	-e DB_NAME=postfix \
	-e DOMAIN_1=meteor-qs.de \
	-e SPAMCHECK_HOST=meteorit_rspamd\
	-e IMAPPROXY_HOST=meteorit_perdition \
	-e SPAMCHECK_PORT=11332 \
	--hostname 'meteor-qs.de' \
	-e DOMAIN_1=meteor-qs.de \
	-e DOMAIN_2=v22016063665135548.powersrv.de\
	-e KOPANO_HOST_1=meteorit_kopano \
	-e KOPANO_HOST_2=meteorit_kopano2 \
	-v /srv/certs/meteorit/:/tmp/cert:rw \
	-v /etc/localtime:/etc/localtime:ro \
	postfix:3 

