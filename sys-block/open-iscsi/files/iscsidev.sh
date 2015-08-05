#!/usr/bin/env bash

# KERNEL=="sd*", SUBSYSTEMS=="block", RUN{program}="/etc/udev/scripts/iscsidev.sh"

# we only care about iscsi devices
[[ $ID_VENDOR = "IET" ]] || exit 1

# don't care about partitions either
echo $DEVNAME | egrep -q "[0-9]$"
status=$?
[[ $status != 0 ]] || exit 1

#ID_MODEL=VIRTUAL-DISK
#ID_MODEL_ENC=VIRTUAL-DISK
#ID_REVISION=0001
#DEVTYPE=disk
#ID_BUS=scsi
#SUBSYSTEM=block
#ID_SERIAL=1IET_00010001
#DEVPATH=/devices/platform/host74/session68/target74:0:0/74:0:0:1/block/sde
#ID_VENDOR_ENC=IET\x20\x20\x20\x20\x20
#MINOR=64
#ID_SCSI=1
#ACTION=add
#PWD=/
#ID_PART_TABLE_UUID=54f71c65-a5d5-45cd-8915-5ffd5ff4fea6
#ID_FS_TYPE=
#USEC_INITIALIZED=999037905
#MAJOR=8
#ID_SCSI_SERIAL=beaf11
#DEVLINKS=/dev/disk/by-id/scsi-1IET_00010001
#DEVNAME=/dev/sde
#SHLVL=1
#ID_TYPE=disk
#ID_PART_TABLE_TYPE=gpt
#ID_VENDOR=IET
#ID_SERIAL_SHORT=IET_00010001
#SEQNUM=25775

# do the removal
if [[ $ACTION = 'remove' ]]; then
  find -L /dev/disk/by-path/ -type l -lname ${DEVNAME} -exec rm "{}" + 2>/dev/null
  exit 0
fi

TARGET_NAME=$(lsscsi -t | grep "${DEVNAME}" | awk '{print $3}' | awk -F, '{print $1}')
[[ $TARGET_NAME = '' ]] && exit 1

# we don't know which host is correct
declare -a POSSIBLE_HOSTS
declare -a POSSIBLE_PORTS
for item in $(cat /sys/class/iscsi_connection/connection*/address); do
  POSSIBLE_HOSTS+=("${item}")
done
for item in $(cat /sys/class/iscsi_connection/connection*/port); do
  POSSIBLE_PORTS+=("${item}")
done

#get correct ip and port
for ((i=0;i<${#POSSIBLE_HOSTS[@]};++i)); do
  printf "%s is in %s\n" "$POSSIBLE_HOSTS[i]}" "${POSSIBLE_PORTS[i]}"
  iscsiadm --mode node --targetname "${TARGET_NAME}" -p "${POSSIBLE_HOSTS[i]}":"${POSSIBLE_PORTS[i]}"
  status=$?
  if [[ $status = 0 ]]; then
    TARGET_IP="${POSSIBLE_HOSTS[i]}"
    TARGET_PORT="${POSSIBLE_PORTS[i]}"
    break
  fi
done

# exit if not found
[[ -z $TARGET_IP ]] && exit 1
[[ -z $TARGET_PORT ]] && exit 1

# actually create the link
mkdir -p /dev/disk/by-path/
ln -s "${DEVNAME}" "/dev/disk/by-path/ip-${TARGET_IP}:${TARGET_PORT}-iscsi-${TARGET_NAME}-lun-1"