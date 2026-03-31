#!/bin/bash
#
# systemd helper script for openafs-client.service. This is only intended to be
# called from the openafs-client.service unit file.

set -e

UMOUNT_TIMEOUT=30

case $1 in
    ExecStart)
	if fs sysname >/dev/null 2>&1 ; then
	    # If we previously tried to stop the client and failed (because
	    # e.g. /afs was in use), our unit will be deactivated but the
	    # client will keep running. So if we're starting up, but the client
	    # is currently running, do not perform the startup sequence but
	    # just return success, to let the unit activate, so stopping the
	    # unit can go through the shutdown sequence again.
	    echo AFS client appears to be running -- skipping startup
	    exit 0
	fi

	# If the kernel module is already initialized from a previous client
	# run, it must be unloaded and loaded again. So if the module is
	# currently loaded, unload it in case it was (partly) initialized.
	if lsmod | grep -wq ^libafs ; then
	    /sbin/rmmod --verbose libafs
	fi

	CACHEDIR=$(cut -d ':' -f 2 /etc/openafs/cacheinfo)
	if ! mkdir -p "${CACHEDIR}"; then
		echo "Unable to create cache dir ${CACHEDIR}"
		exit 1
	fi

	/sbin/modprobe --verbose libafs
	exec /usr/sbin/afsd $AFSD_ARGS $AFSD_CACHE_ARGS
	;;

    ExecStop)
	if /bin/umount --verbose /afs ; then
	    exit 0
	else
	    echo "Failed to unmount /afs: $?"
	fi

	state=$(systemctl is-system-running || true)
	if [ "$state" = stopping ] && [ x"$UMOUNT_TIMEOUT" != x ] && /bin/mountpoint --quiet /afs ; then
	    # If we are shutting down the system, failing to umount /afs
	    # can lead to longer delays later as systemd tries to forcibly
	    # kill our afsd processes. So retry the umount a few times,
	    # just in case other /afs-using processes just need a few
	    # seconds to go away.
	    echo "For system shutdown, retrying umount /afs for $UMOUNT_TIMEOUT secs"
	    interval=3
	    for (( i = 0; i < $UMOUNT_TIMEOUT; i += $interval )) ; do
		sleep $interval
		if /bin/umount --verbose /afs ; then
		    exit 0
		fi
		if ! /bin/mountpoint --quiet /afs ; then
		    echo "mountpoint /afs disappeared; bailing out"
		    exit 0
		fi
	    done
	    echo "Still cannot umount /afs, bailing out"
	fi
	exit 1
	;;

    ExecStopPost)
	/usr/sbin/afsd -shutdown || true
	/sbin/rmmod --verbose libafs || true
	if lsmod | grep -wq ^libafs ; then
	    echo "Cannot unload the OpenAFS client kernel module."
	    echo "systemd will consider the openafs-client.service unit inactive, but the AFS client may still be running."
	    echo "To stop the client, stop all access to /afs, and then either:"
	    echo "stop the client manually:"
	    echo "    umount /afs"
	    echo "    rmmod libafs"
	    echo "or start and stop the openafs-client.service unit:"
	    echo "    systemctl start openafs-client.service"
	    echo "    systemctl stop openafs-client.service"
	    echo 'See "journalctl -u openafs-client.service" for details.'
	    exit 1
	fi
	exit 0
	;;
esac

echo "Usage: $0 {ExecStart|ExecStop|ExecStopPost}" >&2
exit 1
