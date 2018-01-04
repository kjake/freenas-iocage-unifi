# UniFi Controller Jail for FreeNAS

Currently installs UniFi 5.6.26 with Let's Encrypt auto-renew support!

This Jail makes use of VNET emulated/virtual network interfaces rather than sharing your main interface; this is needed for proper network discovery, but may not be required as this Jail is tested more.

### Persistent Storage
The jail mounts _unifi/cert_, _unifi/data_, _unifi/logs_, and _unifi/dehydrated_ outside of the jail for persistent storage of the UniFi/LE files.
The jail also mounts _portsnap/ports_ and _portsnap/db_ outside of the jail for persistent storage of the Ports files; useful when you're building things over multiple jails.

_These persistent jail mounts are technically optional as the installation or OS will create them as needed, but they will become part of the jail and lost if the jail is destroyed, resulting in a complete re-configure of the UniFi Controller on the next build of the jail. If you chose to not use persistent jail mounts, remove them from the unifi_jail.sh before running._

### Steps For UniFi Use
1. Decide where the persistant storage paths will go and update the paths within _unifi_jail.sh_ 
1. Update the IPs within _unifi_jail.sh_ (UNIFI_IP and DEFAULT_GW_IP)
1. Place all of the files with in the _bin_ directory of this repo within the _unifi/dehydrated_ directory before you run the main jail script.
1. Put _unifi_jail.sh_ somewhere accessible on your FreeNAS system and run it.
1. Management page will be available at https://[HOSTNAME]:8443/.

### Steps for Let's Encrypt
##### Caveat
Let's Encrypt has a bunch of manual setup and this has only been tested as a DNS-01 challenge with CloudFlare. However, once this is setup, with the persistant storage, you'll never really have to do this again.

Pre-requisites (after running main script):
* CloudFlare Account (Basic/Free works) and Global API Key
* One public domain setup in CloudFlare
* FQDN created on your internal DNS that will resolve to your UniFi Controller's IP; the FQDN must use the same domain name, but does not need a record created in CloudFlare, only on the internal DNS.
   * Example: I own example.com and its DNS is handled by CloudFlare. I create a record on my internal DNS server for unifi.example.com to point to 172.16.10.2 and use that IP address for my Jail as that is part of my internal network.

1. Edit _domains.txt_ file in _unifi/dehydrated_ and place your FQDN there (ex. unifi.example.com).

TODO:
- [ ] Test if openssl.cnf settings are nessessary
- [ ] Test higher encryption keys
- [ ] Document dehydrated config
- [ ] Document dehydrated first-run



##### Footnotes
###### <a name="dehydrated">1</a>: https://b3n.org/intranet-ssl-certificates-using-lets-encrypt-dns-01/


