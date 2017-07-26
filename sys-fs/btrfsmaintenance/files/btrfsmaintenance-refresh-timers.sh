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


if [ -f /etc/sysconfig/btrfsmaintenance ]; then
    . /etc/sysconfig/btrfsmaintenance
fi

if [ -f /etc/default/btrfsmaintenance ]; then
    . /etc/default/btrfsmaintenance
fi


refresh_period() {
	PERIOD="$1"
	SERVICE="$2"
	echo "Refresh script $SERVICE for $PERIOD"

	case "$PERIOD" in
		daily|weekly|monthly)
			mkdir -p /etc/systemd/system/"$SERVICE".timer.d/
			cat << EOF > /etc/systemd/system/"$SERVICE".timer.d/schedule.conf
[Timer]
OnCalendar=$PERIOD
EOF
			systemctl enable "$SERVICE".timer &> /dev/null
			systemctl start "$SERVICE".timer &> /dev/null
			;;
		*)
			systemctl stop "$SERVICE".timer &> /dev/null
			systemctl disable "$SERVICE".timer &> /dev/null
			rm -rf /etc/systemd/system/"$SERVICE".timer.d
			;;
	esac
}

if [ "$1" = 'uninstall' ]; then
	for SERVICE in btrfs-scrub btrfs-defrag btrfs-balance btrfs-trim; do
		refresh_period uninstall $SERVICE
	done
	exit 0
fi

refresh_period "$BTRFS_SCRUB_PERIOD" btrfs-scrub
refresh_period "$BTRFS_DEFRAG_PERIOD" btrfs-defrag
refresh_period "$BTRFS_BALANCE_PERIOD" btrfs-balance
refresh_period "$BTRFS_TRIM_PERIOD" btrfs-trim
