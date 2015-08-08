# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: mount-boot.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @BLURB: functions for packages that install files into /boot
# @DESCRIPTION:
# This eclass is really only useful for bootloaders.
#
# If the live system has a separate /boot partition configured, then this
# function tries to ensure that it's mounted in rw mode, exiting with an
# error if it can't. It does nothing if /boot isn't a separate partition.

EXPORT_FUNCTIONS pkg_pretend pkg_preinst pkg_postinst pkg_prerm pkg_postrm

# @FUNCTION: mount-boot_disabled
# @INTERNAL
# @DESCRIPTION:
# Detect whether the current environment/build settings are such that we do not
# want to mess with any mounts.
mount-boot_is_disabled() {
	# Since this eclass only deals with /boot, skip things when ROOT is active.
	if [[ "${ROOT:-/}" != "/" ]] ; then
		return 0
	fi

	# If we're only building a package, then there's no need to check things.
	if [[ "${MERGE_TYPE}" == "buildonly" ]] ; then
		return 0
	fi

	# The user wants us to leave things be.
	if [[ -n ${DONT_MOUNT_BOOT} ]] ; then
		return 0
	fi

	# OK, we want to handle things ourselves.
	return 1
}

# @FUNCTION: mount-boot_check_status
# @INTERNAL
# @DESCRIPTION:
# Figure out what kind of work we need to do in order to have /boot be sane.
# Return values are:
# 0 - Do nothing at all!
# 1 - It's mounted, but is currently ro, so need to remount rw.
# 2 - It's not mounted, so need to mount it rw.
mount-boot_check_status() {
	# Get out fast if possible.
	mount-boot_is_disabled && return 0

	# note that /dev/BOOT is in the Gentoo default /etc/fstab file
	local fstabstate=$(awk '!/^#|^[[:blank:]]+#|^\/dev\/BOOT/ {print $2}' /etc/fstab | egrep "^/boot$" )
	local procstate=$(awk '$2 ~ /^\/boot$/ {print $2}' /proc/mounts)
	local proc_ro=$(awk '{ print $2 " ," $4 "," }' /proc/mounts | sed -n '/\/boot .*,ro,/p')

	if [ -n "${fstabstate}" ] && [ -n "${procstate}" ] ; then
		if [ -n "${proc_ro}" ] ; then
			echo
			einfo "Your boot partition, detected as being mounted at /boot, is read-only."
			einfo "It will be remounted in read-write mode temporarily."
			return 1
		else
			echo
			einfo "Your boot partition was detected as being mounted at /boot."
			einfo "Files will be installed there for ${PN} to function correctly."
			return 0
		fi
	elif [ -n "${fstabstate}" ] && [ -z "${procstate}" ] ; then
		echo
		einfo "Your boot partition was not mounted at /boot, so it will be automounted for you."
		einfo "Files will be installed there for ${PN} to function correctly."
		return 2
	else
		echo
		einfo "Assuming you do not have a separate /boot partition."
		return 0
	fi
}

mount-boot_pkg_pretend() {
	# Get out fast if possible.
	mount-boot_is_disabled && return 0

	elog "To avoid automounting and auto(un)installing with /boot,"
	elog "just export the DONT_MOUNT_BOOT variable."
	mount-boot_check_status
}

mount-boot_mount_boot_partition() {
	mount-boot_check_status
	case $? in
	0)	# Nothing to do.
		;;
	1)	# Remount it rw.
		mount -o remount,rw /boot
		if [ $? -ne 0 ] ; then
			echo
			eerror "Unable to remount in rw mode. Please do it manually!"
			die "Can't remount in rw mode. Please do it manually!"
		fi
		touch /boot/.e.remount
		;;
	2)	# Mount it rw.
		mount /boot -o rw
		if [ $? -ne 0 ] ; then
			echo
			eerror "Cannot automatically mount your /boot partition."
			eerror "Your boot partition has to be mounted rw before the installation"
			eerror "can continue. ${PN} needs to install important files there."
			die "Please mount your /boot partition manually!"
		fi
		touch /boot/.e.mount
		;;
	esac
}

mount-boot_pkg_preinst() {
	# Handle older EAPIs.
	case ${EAPI:-0} in
	[0-3]) mount-boot_pkg_pretend ;;
	esac

	mount-boot_mount_boot_partition
}

mount-boot_pkg_prerm() {
	touch "${ROOT}"/boot/.keep 2>/dev/null
	mount-boot_mount_boot_partition
	touch "${ROOT}"/boot/.keep 2>/dev/null
}

mount-boot_umount_boot_partition() {
	# Get out fast if possible.
	mount-boot_is_disabled && return 0

	if [ -e /boot/.e.remount ] ; then
		einfo "Automatically remounting /boot as ro as it was previously."
		rm -f /boot/.e.remount
		mount -o remount,ro /boot
	elif [ -e /boot/.e.mount ] ; then
		einfo "Automatically unmounting /boot as it was previously."
		rm -f /boot/.e.mount
		umount /boot
	fi
}

mount-boot_pkg_postinst() {
	mount-boot_umount_boot_partition
}

mount-boot_pkg_postrm() {
	mount-boot_umount_boot_partition
}
