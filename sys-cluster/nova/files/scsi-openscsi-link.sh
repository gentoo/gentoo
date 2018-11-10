#!/bin/bash

# Author: Geaaru
# Date: October 23, 2014
# Version: 0.1.0
# License: GPL 2.0

# Description: Script for udev symlink creation of
#              scsi disk attached and visible under
#              /dev/disk/by-path/ with name convention
#              used in openstack LVM iscsi driver.
#
# Requirements: lsscsi (for retrieve LUN ID, I don't know how can i do that from udev/iscsiadm)

# Rules for UDEV must in this format:
# KERNEL=="sd*", BUS=="scsi", PROGRAM="/etc/nova/scsi-openscsi-link.sh %b",SYMLINK+="disk/by-path/%c"

# NOTE: it seems that input params %b or others are not passed to script.
#       I try to retrieve it from environment variables.

if [[ -z "$DEVTYPE" || -z "$ID_BUS" ]] ; then
	exit 1
fi
   
echo "--------------------" >> /tmp/udev.log
echo "ENV => `env`" >> /tmp/udev.log
echo "--------------------" >> /tmp/udev.log

if [[ $DEVTYPE != "disk" || $ID_BUS != "scsi" ]]; then
        echo "EXIT 1" >> /tmp/udev.log
        exit 1
fi

# ID_SCSI variable what identify ?

HOST=`echo  "$DEVPATH" | awk '{ split($0, word, "/"); print substr(word[4], 5); }'`



# Bins
iscsiadm=/usr/sbin/iscsiadm
lsscsi=/usr/bin/lsscsi

[ -e /sys/class/iscsi_host ] || exit 1

# Create file path like this:
# /sys/class/iscsi_host/host11/device/session3/iscsi_session/session3/targetname
file="/sys/class/iscsi_host/host${HOST}/device/session*/iscsi_session*/session*/targetname"

target_iqn=$(cat ${file})

if [ -z "${target_iqn}" ] ; then
        echo "EXIT 2" >> /tmp/udev.log
	exit 1
fi

# Retrieve target_port because I can't retrieve it with iscsi_id
# /lib/udev/scsi_id -g -x /dev/sdg
# ID_SCSI=1
# ID_VENDOR=IET
# ID_VENDOR_ENC=IET\x20\x20\x20\x20\x20
# ID_MODEL=VIRTUAL-DISK
# ID_MODEL_ENC=VIRTUAL-DISK
# ID_REVISION=0001
# ID_TYPE=disk
# ID_SERIAL=1IET_00010001
# ID_SERIAL_SHORT=IET_00010001
# ID_SCSI_SERIAL=                              beaf11a

# iscsiadm -m node | grep --colour=none  iqn.2014-09.org.openstack:vol-cinder-f48f0a69-e871-4c47-9cd3-3ccb8c811363 | cut -d',' -f 1

tp_ispresent=$(${iscsiadm} -m node | grep --colour=none ${target_iqn} | wc -l)
if [ x$tp_ispresent = x0 ] ; then
      # Target is not present. Ignore it.
        echo "EXIT 3" >> /tmp/udev.log
      exit 1
fi

target_portal=$(${iscsiadm} -m node | grep --colour=none ${target_iqn} | cut -d',' -f 1)
#target=$(${iscsiadm} -m node | grep --colour=none ${target_iqn} | cut -d' ' -f 1)
#target_portal=$(echo ${target} | cut -d',' -f 1)
target_lun=$(${lsscsi} | grep $DEVNAME | sed 's/.[0-9]*:[0-9]*:[0-9]*:\([0-9]*\).*/\1/')

echo "TARGET_PORTAL=$target_portal" >> /tmp/udev.log
echo "TARGET_LUN=$target_lun" >> /tmp/udev.log

linkname="ip-${target_portal}-iscsi-${target_iqn}-lun-${target_lun}"

echo "RETURN ${linkname}" >> /tmp/udev.log

echo "${linkname}"

exit 0
