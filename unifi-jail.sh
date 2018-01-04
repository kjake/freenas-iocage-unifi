#!/bin/sh
JAIL_IP=xxx.xxx.xxx.xxx
JAIL_PATH=/zfs/dataset/not/part/of/iocage/jails
JAIL_NAME=unifi
DEFAULT_GW_IP=xxx.xxx.xxx.xxx

iocage stop ${JAIL_NAME}
iocage destroy -f ${JAIL_NAME}
echo '{"pkgs":["openjdk8","python","mongodb","bash","snappyjava","gmake","gettext","indexinfo","zip","git","dehydrated","py27-pip"]}' > /tmp/pkg.json
iocage create --name "${JAIL_NAME}" -p /tmp/pkg.json -r 11.1-RELEASE ip4_addr="vnet0|${JAIL_IP}/24" vnet="on" allow_raw_sockets="1" defaultrouter="${DEFAULT_GW_IP}" boot="on" host_hostname="${JAIL_NAME}" mount_linprocfs="1"
rm /tmp/pkg.json
iocage fstab -a ${JAIL_NAME} linproc /proc linprocfs rw 0 0
iocage fstab -a ${JAIL_NAME} ${JAIL_PATH}/portsnap/ports /usr/ports nullfs rw 0 0
iocage fstab -a ${JAIL_NAME} ${JAIL_PATH}/portsnap/db /var/db/portsnap nullfs rw 0 0
iocage fstab -a ${JAIL_NAME} ${JAIL_PATH}/${JAIL_NAME}/data /usr/local/share/java/unifi/data nullfs rw 0 0
iocage fstab -a ${JAIL_NAME} ${JAIL_PATH}/${JAIL_NAME}/logs /usr/local/share/java/unifi/logs nullfs rw 0 0
iocage fstab -a ${JAIL_NAME} ${JAIL_PATH}/${JAIL_NAME}/dehydrated /etc/dehydrated nullfs rw 0 0
iocage exec ${JAIL_NAME} "if [ -z /usr/ports ]; then portsnap fetch extract; else portsnap auto; fi"
iocage exec ${JAIL_NAME} make -C /usr/ports/net-mgmt/unifi5 clean install BATCH=yes
iocage exec ${JAIL_NAME} sh /etc/dehydrated/install.sh
iocage exec ${JAIL_NAME} chown -R unifi /usr/local/share/java/unifi
iocage exec ${JAIL_NAME} sysrc -f /etc/rc.conf ${JAIL_NAME}_enable="YES"
iocage exec ${JAIL_NAME} sysrc -f /etc/rc.conf mongod_enable="NO"
iocage exec ${JAIL_NAME} sysrc -f /etc/periodic.conf weekly_dehydrated_enable="YES"
iocage exec ${JAIL_NAME} sysrc -f /etc/periodic.conf weekly_dehydrated_deployscript="/etc/dehydrated/deploy.sh""
iocage restart ${JAIL_NAME}
iocage exec ${JAIL_NAME} sh /etc/dehydrated/deploy.sh
