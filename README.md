# UniFi Controller Jail for FreeNAS

Currently installs UniFi 5.6.26 with Let's Encrypt auto-renew support!

This Jail makes use of VNET emulated/virtual network interfaces rather than sharing your main interface; this is needed for proper network discovery, but may not be required as this Jail is tested more.

### Persistent Storage
The jail mounts paths that I call _unifi/data_, _unifi/logs_, and _unifi/dehydrated_ outside of the jail for persistent storage of the UniFi/LE files.
The jail also mounts _portsnap/ports_ and _portsnap/db_ outside of the jail for persistent storage of BSD Ports files; useful when you're building things over multiple jails.

_These persistent jail mounts are technically optional as the installation or OS will create them as needed, but they will become part of the jail and lost if the jail is destroyed, resulting in a complete re-configure of the UniFi Controller on the next build of the jail. If you chose to not use persistent jail mounts, remove them from the unifi-jail.sh before running._

### Let's Encrypt Pre-requisites
Let's Encrypt has a little bit of manual setup. This has only been tested as a DNS-01 challenge with CloudFlare. However, once this is setup, with the persistant storage, you'll never really have to do this again.

The script defaults to generating a valid LE-issued SSL certificate with Dehydrated<sup>[1](#dehydrated)</sup>. If you don't want to use this, remove references to dehydrated from the _unifi-jail.sh_ script and UniFi will use a self-signed certificate. Steps below are listed with OPT for Optional as they are related to the Dehydrated client setup.

* CloudFlare Account (Basic/Free works) and Global API Key
* One public domain setup in CloudFlare
* FQDN created on your internal DNS that will resolve to your UniFi Controller's IP; the FQDN must use the same domain name, but does not need a record created in CloudFlare, only on the internal DNS.
   * Example: I own example.com and its DNS is handled by CloudFlare. I create a record on my internal DNS server for unifi.example.com to point to 172.16.10.2 and use that IP address for my Jail as that is part of my internal network.

### Steps For Use
1. Update _JAIL_PATH_, _JAIL_IP_, and _DEFAULT_GW_IP_ inside of _unifi-jail.sh_.  Change _JAIL_NAME_ if you want to.
1. (OPT) Put the files within the repo's _bin_ directory into the _unifi/dehydrated_ directory before you run the main jail script.
1. (OPT) Place your UniFi Controller's fully qualified domain name (FQDN, i.e. unifi.example.com) into _unifi/dehydrated/domains.txt_.
1. (OPT) Update _FQDN_ variable in _unifi/dehydrated/deploy.sh_.
1. (OPT) Create _unifi/dehydrated/config_ using the bare config below.
1. Put _unifi-jail.sh_ somewhere accessible on your FreeNAS system and run it.
1. Management page will be available at https://[FQDN]:8443/.

_unifi/dehydrated/config_:
```shell
CHALLENGETYPE="dns-01"
CERTDIR="${BASEDIR}/certs"
ACCOUNTDIR="${BASEDIR}/accounts"
HOOK=/opt/letsencrypt-cloudflare-hook/hook.py
CONTACT_EMAIL=user@example.com
export CF_EMAIL='user@example.com'
export CF_KEY='KEUMY69kDTErhFHZXSrvMS'
```

##### Footnotes
###### <a name="dehydrated">1</a>: https://b3n.org/intranet-ssl-certificates-using-lets-encrypt-dns-01/


