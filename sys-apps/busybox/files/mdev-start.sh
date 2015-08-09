# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

find_mdev()
{
	if [ -x /sbin/mdev ] ; then
		echo "/sbin/mdev"
	else
		echo "/bin/busybox mdev"
	fi
}

populate_mdev()
{
	# populate /dev with devices already found by the kernel

	if get_bootparam "nocoldplug" ; then
		RC_COLDPLUG="no"
		ewarn "Skipping mdev coldplug as requested in kernel cmdline"
	fi

	ebegin "Populating /dev with existing devices with mdev -s"
	$(find_mdev) -s
	eend $?

	return 0
}

seed_dev()
{
	# Seed /dev with some things that we know we need

	# creating /dev/console and /dev/tty1 to be able to write
	# to $CONSOLE with/without bootsplash before mdev creates it
	[ -c /dev/console ] || mknod /dev/console c 5 1
	[ -c /dev/tty1 ] || mknod /dev/tty1 c 4 1

	# udevd will dup its stdin/stdout/stderr to /dev/null
	# and we do not want a file which gets buffered in ram
	[ -c /dev/null ] || mknod /dev/null c 1 3

	# copy over any persistant things
	if [ -d /lib/mdev/devices ] ; then
		cp -RPp /lib/mdev/devices/* /dev 2>/dev/null
	fi

	# Not provided by sysfs but needed
	ln -snf /proc/self/fd /dev/fd
	ln -snf fd/0 /dev/stdin
	ln -snf fd/1 /dev/stdout
	ln -snf fd/2 /dev/stderr
	[ -e /proc/kcore ] && ln -snf /proc/kcore /dev/core

	# Create problematic directories
	mkdir -p /dev/pts /dev/shm
}

mount_it_b1()
{
	if [ "${RC_USE_FSTAB}" = "yes" ] ; then
		mntcmd=$(get_mount_fstab /dev)
	else
		unset mntcmd
	fi
	if [ -n "${mntcmd}" ] ; then
		try mount -n ${mntcmd}
	else
		if grep -Eq "[[:space:]]+tmpfs$" /proc/filesystems ; then
			mntcmd="tmpfs"
		else
			mntcmd="ramfs"
		fi
		# many video drivers require exec access in /dev #92921
		try mount -n -t "${mntcmd}" -o exec,nosuid,mode=0755 mdev /dev
	fi
}
mount_it_b2()
{
	if fstabinfo --quiet /dev ; then
		mount -n /dev
	else
		# Some devices require exec, Bug #92921
		mount -n -t tmpfs -o "exec,nosuid,mode=0755,size=10M" mdev /dev
	fi
}
mount_it()
{
	type fstabinfo && mount_it_b2 || mount_it_b1
}

main()
{
	# Setup temporary storage for /dev
	ebegin "Mounting /dev for mdev"
	mount_it
	eend $?

	# Create a file so that our rc system knows it's still in sysinit.
	# Existance means init scripts will not directly run.
	# rc will remove the file when done with sysinit.
	touch /dev/.rcsysinit

	# Selinux lovin; /selinux should be mounted by selinux-patched init
	if [ -x /sbin/restorecon ] && [ -c /selinux/null ] ; then
		restorecon /dev > /selinux/null
	fi

	seed_dev

	# Setup hotplugging (if possible)
	if [ -e /proc/sys/kernel/hotplug ] ; then
		ebegin "Setting up proper hotplug agent"
		eindent
		einfo "Setting /sbin/mdev as hotplug agent ..."
		echo $(find_mdev) > /proc/sys/kernel/hotplug
		eoutdent
		eend 0
	fi

	populate_mdev
}

main

# vim:ts=4
