#!/bin/sh

mkdir -p /etc/dehydrated/accounts
if [ -z /etc/dehydrated/config ]; then cp /usr/local/etc/dehydrated/config.example /etc/dehydrated/config; fi
if [ -z /etc/dehydrated/domains.txt ]; then cp /usr/local/etc/dehydrated/domains.txt.example /etc/dehydrated/domains.txt; fi
mkdir /opt && cd /opt && git clone https://github.com/kappataumu/letsencrypt-cloudflare-hook && pip install -r letsencrypt-cloudflare-hook/requirements-python-2.txt
dehydrated --register --accept-terms
