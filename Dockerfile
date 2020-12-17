FROM debian:buster-slim

EXPOSE 25

ENV POSTFIX_DOMAIN=yourdomain.tld
ENV POSTFIX_MAILNAME=yourreversednsmailhost
ENV POSTFIX_APPEND_VIRTUAL_ALIAS_CF=yes
ENV POSTFIX_APPEND_MYDESTINATION_CF=yes

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
    apt-get install -q -y apt-utils
RUN apt-get update &&\
    /bin/bash -c 'debconf-set-selections <<< "postfix postfix/mailname string ${POSTFIX_MAILNAME}"' &&\
    /bin/bash -c 'debconf-set-selections <<< "postfix postfix/main_mailer_type string Internet Site"' &&\
    apt-get install -q -y rsyslog postfix postfix-policyd-spf-python

ADD main.cf /etc/postfix/main.cf
ADD logrotate.conf /etc/logrotate.conf
ADD rsyslog /etc/logrotate.d/rsyslog

ADD start_script.sh /
RUN chmod +x /start_script.sh

CMD ["/start_script.sh"]


