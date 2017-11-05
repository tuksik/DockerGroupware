FROM ubuntu:16.04

MAINTAINER meteorIT GbR Marcus Kastner

EXPOSE 993
EXPOSE 80
EXPOSE 2003

ENV DB_HOST=localhost \
	DB_USER=kopano \
	DB_PASS=kopano \
	DB_NAME=kopano \
	DOMAIN=localhost.local \
	SMTP_SERVER=localhost \
	SPAM_HEADER=X-Spam \
	SPAM_VALUE=Yes

	

WORKDIR /tmp

RUN  mkdir -p core webapp files mdm template installfiles /usr/share/z-push

RUN apt-get update \
    && apt-get install -y vim rsyslog gsoap-dbg php-mbstring gettext swaks wget tar libjs-backbone apache2 libapache2-mod-php\
	&& apt-get  --purge remove 'exim4*'

ADD  installfiles /tmp/installfiles


RUN tar xfvz installfiles/core.tar.gz --strip-components=1  -C core \
	&& tar xfvz installfiles/webapp.tar.gz --strip-components=1  -C webapp \
	&& tar xfvz installfiles/files.tar.gz --strip-components=1  -C files  \
	&& tar xfvz installfiles/mdm.tar.gz --strip-components=1  -C mdm \
	&& tar zxvf installfiles/z-push.tar.gz --strip-components=1 -C /usr/share/z-push/ \
	&& rm -r installfiles/*.tar.gz


RUN rm core/gsoap* \
	&& dpkg -i core/*.deb 2> /dev/null ; apt --fix-broken -y install  && dpkg -i core/*.deb \
	&& dpkg -i webapp/*.deb 2> /dev/null ; apt --fix-broken -y install  && dpkg -i webapp/*.deb \
	&& dpkg -i files/*.deb 2> /dev/null ; apt --fix-broken -y install  && dpkg -i files/*.deb \
	&& dpkg -i mdm/*.deb 2> /dev/null ; apt --fix-broken -y install  && dpkg -i mdm/*.deb

ADD template /tmp/template
ADD entrypoint.sh /tmp	
	
RUN mkdir /var/lib/z-push /var/log/z-push \
	&& chown www-data:www-data /var/lib/z-push /var/log/z-push \
	&& chmod 755 /tmp/entrypoint.sh


ENTRYPOINT ["/tmp/entrypoint.sh"] 