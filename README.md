Stuck in the mailer with you
============================

## A dockerized postfix email relay for the generally (in)sane

DKIM, SPF, DMARC, MX, PTR, SASL, /etc/mailname, helo/ehlo restrictions, sender restrictions, recipient restrictions, relay restrictions, permit networks, white listing, black listing, GRAY listing, throttling, logrotating, spam filtering, policy, reports, alerts, AWS request forms to authorize outgoing connections... DAMN YOU LAW OF SOFTWARE ENVELOPMENT AND YOUR GAPING BLACK HOLE OF ANCIENT TECHNOLOGY.


```
docker run -d -p "25:25" \
    --log-opt max-size=10m --log-opt max-file=5 \
    -e POSTFIX_DOMAIN=yourdomain.tld \
    -e POSTFIX_MAILNAME=mailerpublichostname \
    -e POSTFIX_RELAY_TO_ADDRESS=youraccount@youremailprovider \
    --name postfix \
    stuckinthemailerwithyou
```

Merry the-festivity-also-known-as-christmas.

Please,

 - Read the license.
 - Use responsibly. 
 - Try to avoid turning your service into a spam beacon, even though that's nowhere near what this technology's foundation is about and we are all set up to fail miserably under layers and layers of misconfigured and complex rules interacting with each other while spammers throw at it truckloads of money to mess it all up even more. 
 - Check out [these tips](postfix_safety_goals.md)).
 - And [mail.cf](mail.cf baseline config) you may want to override via volume.
 - And [start_script.sh](instance-dependant config appends) you may want to disable via env vars if you override them via volume.
 - And [virtual.template](virtual.template) which provides examples to override `/etc/postfix/virtual` via volume if you want to set the configuration for more than one domain or accounts in the domain or relay destinations for an account or accounts, instead of relying to a single destination via `POSTFIX_RELAY_TO_ADDRESS` env var.

Contributions: Submit your PR or ticket/comment with your grievance/request to https://github.com/elcodedocle/stuckinthemailerwithyou

Donations: https://bit.ly/3mmvkXN (Proceeds go to a local animal shelter)

Enjoy!

