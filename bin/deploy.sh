#!/bin/sh

UNIFI=/usr/local/share/java/unifi
CERTS=/etc/dehydrated/certs
FQDN=unifi.example.com

if [ ! -e ${CERTS}/${FQDN}/fullchain.pem ]; then dehydrated -c; fi
if [ -z ${CERTS}/${FQDN}/fullchain.pem ]; then exit 1; fi

openssl pkcs12 -export -in ${CERTS}/${FQDN}/fullchain.pem -inkey ${CERTS}/${FQDN}/privkey.pem -out ${CERTS}/${FQDN}/signed.p12 -name ${JAIL_NAME} -password pass:aircontrolenterprise
keytool -importkeystore -deststorepass aircontrolenterprise -destkeypass aircontrolenterprise -destkeystore ${UNIFI}/data/keystore -srckeystore ${CERTS}/${FQDN}/signed.p12 -srcstoretype PKCS12 -srcstorepass aircontrolenterprise -alias ${JAIL_NAME} -noprompt
service ${JAIL_NAME} restart
