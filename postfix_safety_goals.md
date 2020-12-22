This is *not a complete or universal list*, but the best and most generic I've compiled so far for a basic internet site domain relay/mailer. Most items on this list have been extracted or adapted from [this article](https://www.linuxbabe.com/mail-server/block-email-spam-postfix).

### POSTFIX DEFAULT DEBIAN 'Internet Site' CONFIGURATION TUNING:

This is the postfix config that will be set by default upon container deployment.

 - Enable HELO/EHLO restrictions via `smtpd_helo_required`, `smtpd_helo_restrictions`, `reject_invalid_helo_hostname`, `reject_non_fqdn_helo_hostname`, `reject_unknown_helo_hostname` postfix directives.

```
smtpd_helo_required = yes
smtpd_helo_restrictions =
  permit_mynetworks,
  permit_sasl_authenticated,
  reject_invalid_helo_hostname,
  reject_non_fqdn_helo_hostname,
  reject_unknown_helo_hostname
```
 
 - Reject emails from SMTP clients with no PTR record via `smtpd_sender_restrictions` postfix directive `reject_unknown_reverse_client_hostname` cofiguration value.

 - Allow only SMTP clients with a hostname with valid A Record via `smtpd_sender_restrictions` postfix directive `reject_unknown_client_hostname` configuration value.

 - Restrict MAIL FROM Domain to domains with MX Record or A Record via `smtpd_sender_restrictions` postfix directive `reject_unknown_sender_domain` configuration value.

```
smtpd_sender_restrictions =
  permit_mynetworks,
  permit_sasl_authenticated,
  reject_unknown_sender_domain,
  reject_unknown_reverse_client_hostname,
  reject_unknown_client_hostname
```

 - Blacklist any senders without a valid SPF record or on spamhaus public realtime blacklist via the following `smtpd_recipient_restrictions` postfix directive configuration values:

```
smtpd_recipient_restrictions =
   permit_mynetworks,
   permit_sasl_authenticated,
   check_policy_service unix:private/policy-spf,
   reject_rhsbl_helo dbl.spamhaus.org,
   reject_rhsbl_reverse_client dbl.spamhaus.org,
   reject_rhsbl_sender dbl.spamhaus.org,
   reject_rbl_client zen.spamhaus.org
```

 - Set postfix `smtpd_relay_restrictions` directive to `permit_mynetworks` `permit_sasl_authenticated` `defer_unauth_destination` to only allow authenticated & local connections.

 - Set up OpenDKIM to sign outgoing emails

 - Set up OpenDMARC to Reject Emails That Fail DMARC Check (The provided default configurartion sets a very basic file based solution without dbconf)

### DOMAIN DNS RELATED SETUP

 - Set PTR reverse DNS record.

 - Set SPF TXT DNS record.

 - Set up DKIM keys / DKIM TXT DNS record -> Use the generated `default.txt` echoed on deploy or override `/etc/mail/dkim-keys/${POSTFIX_DOMAIN}/default.private` and `/etc/mail/dkim-keys/${POSTFIX_DOMAIN}/default.txt` via docker volumes.
 
 - Enable TLS encryption in non-opportunistic mode via `smtp_tls_security_level = encrypt`

### OTHER SERVICES

 - Set up fail2ban to stop SMTP AUTH flood attempts.

 - Enable Greylisting in Postfix via postgrey service.

 - Integrate SpamAssassin to detect and filter out spam.

 - Use Pflogsumm via crontab to produce and mail periodical reports to a supervisor email account, in order to detect any unusual activity.

Missing something? Say something! Open a ticket or send your PR.
