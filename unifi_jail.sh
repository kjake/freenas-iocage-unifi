#!/bin/sh

iocage stop unifi
iocage destroy -f unifi
echo '{"pkgs":["openjdk8","python","mongodb","bash","snappyjava","gmake","gettext","indexinfo","zip","git","dehydrated","py27-pip"]}' > /tmp/pkg.json
iocage create --name "unifi" -p /tmp/pkg.json -r 11.1-RELEASE ip4_addr="vnet0|[UNIFI_IP]/24" vnet="on" allow_raw_sockets="1" defaultrouter="[DEFAULT_GW_IP]" boot="on" host_hostname="unifi" mount_linprocfs="1"
rm /tmp/pkg.json
iocage fstab -a unifi linproc /proc linprocfs rw 0 0
iocage fstab -a unifi /mnt/tank/jails/portsnap/ports /usr/ports nullfs rw 0 0
iocage fstab -a unifi /mnt/tank/jails/portsnap/db /var/db/portsnap nullfs rw 0 0
iocage fstab -a unifi /mnt/tank/jails/unifi/data /usr/local/share/java/unifi/data nullfs rw 0 0
iocage fstab -a unifi /mnt/tank/jails/unifi/logs /usr/local/share/java/unifi/logs nullfs rw 0 0
iocage fstab -a unifi /mnt/tank/jails/unifi/cert /usr/local/share/java/unifi/cert nullfs rw 0 0
iocage fstab -a unifi /mnt/tank/jails/unifi/dehydrated /etc/dehydrated nullfs rw 0 0
iocage exec unifi "if [ -z /usr/ports ]; then portsnap fetch extract; else portsnap auto; fi"
iocage exec unifi make -C /usr/ports/net-mgmt/unifi5 clean install BATCH=yes
iocage exec unifi /etc/dehydrated/install.sh
iocage exec unifi /etc/dehydrated/deploy.sh
iocage exec unifi chown -R unifi /usr/local/share/java/unifi
iocage exec unifi sysrc -f /etc/rc.conf mongod_enable="NO"
iocage exec unifi sysrc -f /etc/rc.conf unifi_enable="YES"
iocage exec unifi sysrc -f /etc/rc.conf weekly_dehydrated_enable="YES"
iocage exec unifi sysrc -f /etc/rc.conf weekly_dehydrated_deployscript="/etc/dehydrated/deploy.sh"
iocage restart unifi
