#!/bin/sh

cd /usr/local/share/java/unifi
openssl pkcs12 -export -in cert/[FQDN]/fullchain.pem -inkey cert/[FQDN]/privkey.pem -out cert/[FQDN]/signed.p12 -name unifi -password pass:aircontrolenterprise
keytool -importkeystore -deststorepass aircontrolenterprise -destkeypass aircontrolenterprise -destkeystore data/keystore -srckeystore cert/[FQDN]/signed.p12 -srcstoretype PKCS12 -srcstorepass aircontrolenterprise -alias unifi -noprompt
service unifi restart
