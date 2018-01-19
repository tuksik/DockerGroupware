FROM ubuntu:16.04

MAINTAINER meteorIT GbR Marcus Kastner

EXPOSE 993
EXPOSE 80
EXPOSE 2003

ENV DB_HOST=localhost \
	DB_USER=kopano \
	DB_PASS=kopano \
	DB_NAME=kopano \
	DB_NAME_ZPUSH=zpush \
	DOMAIN=localhost.local \
	SMTP_SERVER=localhost \
	SPAM_HEADER=X-Spam \
	SPAM_VALUE=Yes\
	KOPANO_SERVER_LOGLEVEL=4 \
	KOPANO_SYSTEM_EMAIL="postmaster@localhost" \
	KOPANO_ATTACHMENT_STORAGE=database \
	NGINX_API_KEY="" \
	TIMEZONE="Europe\/Berlin" \
	DEFAULT_THEME="" \
	PHP_UPLOAD_MAX_FILESIZE="2030M" \
	PHP_POST_MAX_SIZE="2040M" \
	PHP_MEMORY_LIMIT="2048M" \
	FPM_MAX_CHILDREN=40


WORKDIR /tmp

ADD installfiles /tmp/installfiles
ADD template /tmp/template
ADD entrypoint.sh /tmp	

#nginx-aplify installation
RUN apt update \
	&& apt -y install curl python2.7 wget \
	&& curl -sS -L -O https://github.com/nginxinc/nginx-amplify-agent/raw/master/packages/install.sh \
	&& sed -i "s/apt-get/apt-get -y/g" install.sh \
	&& sed -i "s/service amplify-agent start/service amplify-agent stop/g" install.sh \
	&& API_KEY=0000 sh ./install.sh 



RUN echo "deb http://repo.z-hub.io/z-push:/final/Ubuntu_16.04/ /" >>  /etc/apt/sources.list.d/z-push.list \
	&& wget -qO - http://repo.z-hub.io/z-push:/final/Ubuntu_16.04/Release.key | apt-key add - \
	&& apt update \
	&& apt install -y vim rsyslog gsoap-dbg php-mbstring gettext wget tar libjs-backbone nginx php7.0-fpm php7.0-mysql language-pack-de language-pack-en openssh-server\
	&& mkdir -p core webapp files mdm template installfiles \
	&& tar xfvz installfiles/core.tar.gz --strip-components=1  -C core \
	&& tar xfvz installfiles/webapp.tar.gz --strip-components=1  -C webapp \
	&& tar xfvz installfiles/files.tar.gz --strip-components=1  -C files  \
	&& tar xfvz installfiles/mdm.tar.gz --strip-components=1  -C mdm \
	&& rm core/gsoap* \
	&& dpkg -i core/*.deb 2> /dev/null ; apt --fix-broken -y install  && dpkg -i core/*.deb && rm -r core \
	&& dpkg -i webapp/*.deb 2> /dev/null ; apt --fix-broken -y install  && dpkg -i webapp/*.deb && rm -r webapp \
	&& dpkg -i files/*.deb 2> /dev/null ; apt --fix-broken -y install  && dpkg -i files/*.deb && rm -r files \
	&& dpkg -i mdm/*.deb 2> /dev/null ; apt --fix-broken -y install  && dpkg -i mdm/*.deb && rm -r mdm \
	&& apt install -y z-push-kopano  z-push-state-sql \
	&& apt  --purge remove 'exim4*' \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt -y autoremove \
	&& rm -r /etc/apache2 \
	&& chmod 755 /tmp/entrypoint.sh


ENTRYPOINT ["/tmp/entrypoint.sh"] 



