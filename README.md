# UniFi Controller Jail for FreeNAS

Currently installs UniFi 5.6.26 with Let's Encrypt auto-renew support!

This Jail makes use of VNET emulated/virtual network interfaces rather than sharing your main interface; this is needed for proper network discovery, but may not be required as this Jail is tested more.

### Persistent Storage
The jail mounts _unifi/cert_, _unifi/data_, _unifi/logs_, and _unifi/dehydrated_ outside of the jail for persistent storage of the UniFi/LE files.
The jail also mounts _portsnap/ports_ and _portsnap/db_ outside of the jail for persistent storage of the Ports files; useful when you're building things over multiple jails.

_These persistent jail mounts are technically optional as the installation or OS will create them as needed, but they will become part of the jail and lost if the jail is destroyed, resulting in a complete re-configure of the UniFi Controller on the next build of the jail. If you chose to not use persistent jail mounts, remove them from the unifi_jail.sh before running._

### Steps For Use
1. Decide where the persistant storage paths will go and update the paths within _unifi_jail.sh_ 
1. Update the IPs within _unifi_jail.sh_ (UNIFI_IP and DEFAULT_GW_IP)
1. Place all of the files with in the _bin_ directory of this repo within the _unifi/dehydrated_ directory before you run the main jail script.
1. Put _unifi_jail.sh_ somewhere accessible on your FreeNAS system and run it.
1. Management page will be available at https://[HOSTNAME]:8443/.
