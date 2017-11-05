FROM debian:9

MAINTAINER meteorIT GbR Marcus Kastner

EXPOSE 25

ENV DB_HOST=localhost \
	DB_USER=kopano \
	DB_PASS=kopano \
	DB_NAME=kopano \
	ENCRYPT_SETTING=may\
	DOMAIN_1=localhost.local\
	KOPANO_HOST_1=localhost \
	SPAMCHECK_HOST=localhost \
	SPAMCHECK_PORT=11332 \
	IMAPPROXY_HOST=localhost
#DOMAIN_1 bis DOMAIN_10 sind möglich (inkl. KOPANO_HOST_1)
	

WORKDIR /tmp

RUN apt-get update &&\
    {\
        echo "postfix postfix/mailname string $DOMAIN_1"; \
        echo  "postfix postfix/main_mailer_type string 'Internet Site'";\
    } | debconf-set-selections  \
	&& apt-get install -y rsyslog postfix postfix-mysql sasl2-bin libsasl2-modules gettext vim \
	&& apt-get --purge -y remove 'exim4*'

	
ADD template/ /tmp/template
ADD entrypoint.sh /tmp

RUN chmod 755 /tmp/entrypoint.sh

ENTRYPOINT ["/tmp/entrypoint.sh"] 
