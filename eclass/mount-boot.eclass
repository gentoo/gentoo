# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/mount-boot.eclass,v 1.18 2011/01/09 03:18:38 vapier Exp $
#
# This eclass is really only useful for bootloaders.
#
# If the live system has a separate /boot partition configured, then this
# function tries to ensure that it's mounted in rw mode, exiting with an
# error if it cant. It does nothing if /boot isn't a separate partition.
#
# MAINTAINER: base-system@gentoo.org

EXPORT_FUNCTIONS pkg_preinst pkg_postinst pkg_prerm pkg_postrm

mount-boot_mount_boot_partition() {
	if [[ -n ${DONT_MOUNT_BOOT} ]] ; then
		return
	else
		elog
		elog "To avoid automounting and auto(un)installing with /boot,"
		elog "just export the DONT_MOUNT_BOOT variable."
		elog
	fi

	# note that /dev/BOOT is in the Gentoo default /etc/fstab file
	local fstabstate=$(awk '!/^#|^[[:blank:]]+#|^\/dev\/BOOT/ {print $2}' /etc/fstab | egrep "^/boot$" )
	local procstate=$(awk '$2 ~ /^\/boot$/ {print $2}' /proc/mounts)
	local proc_ro=$(awk '{ print $2 " ," $4 "," }' /proc/mounts | sed -n '/\/boot .*,ro,/p')

	if [ -n "${fstabstate}" ] && [ -n "${procstate}" ]; then
		if [ -n "${proc_ro}" ]; then
			einfo
			einfo "Your boot partition, detected as being mounted as /boot, is read-only."
			einfo "Remounting it in read-write mode ..."
			einfo
			mount -o remount,rw /boot
			if [ "$?" -ne 0 ]; then
				eerror
				eerror "Unable to remount in rw mode. Please do it manually!"
				eerror
				die "Can't remount in rw mode. Please do it manually!"
			fi
			touch /boot/.e.remount
		else
			einfo
			einfo "Your boot partition was detected as being mounted as /boot."
			einfo "Files will be installed there for ${PN} to function correctly."
			einfo
		fi
	elif [ -n "${fstabstate}" ] && [ -z "${procstate}" ]; then
		mount /boot -o rw
		if [ "$?" -eq 0 ]; then
			einfo
			einfo "Your boot partition was not mounted as /boot, but portage"
			einfo "was able to mount it without additional intervention."
			einfo "Files will be installed there for ${PN} to function correctly."
			einfo
		else
			eerror
			eerror "Cannot automatically mount your /boot partition."
			eerror "Your boot partition has to be mounted rw before the installation"
			eerror "can continue. ${PN} needs to install important files there."
			eerror
			die "Please mount your /boot partition manually!"
		fi
		touch /boot/.e.mount
	else
		einfo
		einfo "Assuming you do not have a separate /boot partition."
		einfo
	fi
}

mount-boot_pkg_preinst() {
	mount-boot_mount_boot_partition
}

mount-boot_pkg_prerm() {
	touch "${ROOT}"/boot/.keep 2>/dev/null
	mount-boot_mount_boot_partition
	touch "${ROOT}"/boot/.keep 2>/dev/null
}

mount-boot_umount_boot_partition() {
	if [[ -n ${DONT_MOUNT_BOOT} ]] ; then
		return
	fi

	if [ -e /boot/.e.remount ] ; then
		einfo
		einfo "Automatically remounting /boot as ro"
		einfo
		rm -f /boot/.e.remount
		mount -o remount,ro /boot
	elif [ -e /boot/.e.mount ] ; then
		einfo
		einfo "Automatically unmounting /boot"
		einfo
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
