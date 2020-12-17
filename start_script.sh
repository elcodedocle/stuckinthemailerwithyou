#!/bin/bash

echo "policy-spf  unix  -       n       n       -       -       spawn" >> /etc/postfix/master.cf
echo "     user=nobody argv=/usr/bin/policyd-spf" >> /etc/postfix/master.cf

echo "myhostname = ${HOSTNAME}.home" >> /etc/postfix/main.cf
if [ ! -z "${POSTFIX_MAILNAME}" ]; then
    echo "${POSTFIX_MAILNAME}" > /etc/mailname
    echo "myorigin = /etc/mailname" >> /etc/postfix/main.cf
    if [ "${POSTFIX_APPEND_MYDESTINATION_CF}" == "yes" ] || [ "${POSTFIX_APPEND_MYDESTINATION_CF}" == "true" ]; then
        echo "mydestination = \$myhostname, ${POSTFIX_MAILNAME}, ${HOSTNAME}, localhost.localdomain, localhost" >> /etc/postfix/main.cf
    fi
else
    if [ "${POSTFIX_APPEND_MYDESTINATION_CF}" == "yes" ] || [ "${POSTFIX_APPEND_MYDESTINATION_CF}" == "true" ]; then
        echo "mydestination = \$myhostname, ${HOSTNAME}, localhost.localdomain, localhost" >> /etc/postfix/main.cf
    fi
fi
if [ "${POSTFIX_APPEND_VIRTUAL_ALIAS_CF}" == "yes" ] || [ "${POSTFIX_APPEND_VIRTUAL_ALIAS_CF}" == "true" ]; then
    echo "virtual_alias_domains = ${POSTFIX_DOMAIN}" >> /etc/postfix/main.cf
    echo "virtual_alias_maps = hash:/etc/postfix/virtual" >> /etc/postfix/main.cf
fi
if [ ! -s /etc/postfix/virtual ] && [ ! -z "${POSTFIX_RELAY_TO_ADDRESS}" ]; then
    echo "@${POSTFIX_DOMAIN} ${POSTFIX_RELAY_TO_ADDRESS}" >> /etc/postfix/virtual
fi
if [ -s /etc/postfix/virtual ]; then
    postmap /etc/postfix/virtual
fi

# postfix start-fg can be used instead without rsyslog or any of the lines below, though it is not nearly as verbose
service rsyslog start
service postfix start
i=0
while [ $i -lt 5 ]
do
  ((i++))
  if test -f "/var/log/mail.log"; then
    echo "Tailing /var/log/mail.log ..."
    break
  fi
  echo "Waiting 1s for postfix to produce a log file to tail..."
  sleep 1
done
tail -f /var/log/mail.log &
# ensure container is terminated when postfix stops
while service postfix status > dev/null
do
 sleep 1
done
kill -HUP $!

