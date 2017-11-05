container=meteorit_rspamd


docker stop $container 2>/dev/null
docker rm $container 2> /dev/null


docker run  -d \
	--network=meteorit_network \
	--name $container \
	-p 8090:80 \
	-e  WEB_PASSWORD=test\
	-e GLOBAL_DNS=46.38.252.230 \
	-e REJECT_VALUE=50 \
    	-e ADD_HEADER_VALUE=4 \
    	-e GREYLIST=20 \
	-v /etc/localtime:/etc/localtime:ro \
	rspamd:1 

