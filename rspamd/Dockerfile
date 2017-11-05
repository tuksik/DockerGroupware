FROM debian:9

MAINTAINER meteorIT GbR Marcus Kastner

EXPOSE 80
EXPOSE 11332

ENV MAX_MEMORY=512mb\
	WEB_PASSWORD=test\
	GLOBAL_DNS=46.38.252.230\
	REJECT_VALUE=50 \
    ADD_HEADER_VALUE=4 \
    GREYLIST_VALUE=20
	
WORKDIR /tmp

RUN apt-get update \
	&& apt-get install -y wget lsb-release vim redis-server gnupg2 gettext \
	&& wget -O- https://rspamd.com/apt-stable/gpg.key | apt-key add - \
	&& CODENAME=`lsb_release -c -s`\
	&& echo "deb http://rspamd.com/apt-stable/ $CODENAME main" > /etc/apt/sources.list.d/rspamd.list\
	&& echo "deb-src http://rspamd.com/apt-stable/ $CODENAME main" >> /etc/apt/sources.list.d/rspamd.list\
	&& apt-get update \
	&& apt-get install -y  rspamd	
	
ADD template/ /tmp/template
ADD entrypoint.sh /tmp

RUN chmod 755 /tmp/entrypoint.sh

ENTRYPOINT ["/tmp/entrypoint.sh"] 
