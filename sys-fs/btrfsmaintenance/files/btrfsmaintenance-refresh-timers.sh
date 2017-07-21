#!/bin/sh
#
# Copyright (c) 2014 SuSE Linux AG, Nuernberg, Germany.
# Copyright (c) 2017 Luigi 'Comio' Mantellini <luigi.mantellini@gmail.com>
#
# please send bugfixes or comments to http://www.suse.de/feedback.

# Adjust symlinks of btrfs maintenance services according to the configs.
# Run with 'uninstall' to remove them again

#
# paranoia settings
#
umask 022
PATH=/sbin:/bin:/usr/sbin:/usr/bin
export PATH

SCRIPTS=/usr/share/btrfsmaintenance

if [ "$1" = 'uninstall' ]; then
	for SERVICE in btrfs-scrub btrfs-defrag btrfs-balance btrfs-trim; do
		for PERIOD in daily weekly monthly; do
			systemctl disable "$SERVICE-$PERIOD".timer
		done
	done
	exit 0
fi

if [ -f /etc/sysconfig/btrfsmaintenance ]; then
    . /etc/sysconfig/btrfsmaintenance
fi

if [ -f /etc/default/btrfsmaintenance ]; then
    . /etc/default/btrfsmaintenance
fi

refresh_period() {
	EXPECTED="$1"
	SERVICE="$2"
	echo "Refresh script $SERVICE for $EXPECTED"

	for PERIOD in daily weekly monthly; do
	        # NOTE: debian does not allow filenames with dots in /etc/cron.*
		if [ "$PERIOD" = "$EXPECTED" ]; then
			systemctl enable "$SERVICE-$PERIOD".timer
		else
		fi
	done
}

refresh_period "$BTRFS_SCRUB_PERIOD" btrfs-scrub
refresh_period "$BTRFS_DEFRAG_PERIOD" btrfs-defrag
refresh_period "$BTRFS_BALANCE_PERIOD" btrfs-balance
refresh_period "$BTRFS_TRIM_PERIOD" btrfs-trim
