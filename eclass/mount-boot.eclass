# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: mount-boot.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: functions for packages that install files into /boot
# @DESCRIPTION:
# This eclass is really only useful for bootloaders.
#
# If the live system has a separate /boot partition configured, then this
# function tries to ensure that it's mounted in rw mode, exiting with an
# error if it can't.  It does nothing if /boot isn't a separate partition.

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: mount-boot_is_disabled
# @INTERNAL
# @DESCRIPTION:
# Detect whether the current environment/build settings are such that we do not
# want to mess with any mounts.
mount-boot_is_disabled() {
	# Since this eclass only deals with /boot, skip things when EROOT is active.
	if [[ ${EROOT:-/} != / ]] ; then
		return 0
	fi

	# If we're only building a package, then there's no need to check things.
	if [[ ${MERGE_TYPE} == buildonly ]] ; then
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
# Check if /boot is sane, i.e., mounted as read-write if on a separate
# partition.  Die if conditions are not fulfilled.  If nonfatal is used,
# the function will return a non-zero status instead.
mount-boot_check_status() {
	# Get out fast if possible.
	mount-boot_is_disabled && return 0

	# note that /dev/BOOT is in the Gentoo default /etc/fstab file
	local fstabstate=$(awk '!/^[[:blank:]]*#|^\/dev\/BOOT/ && $2 == "/boot" \
		{ print 1; exit }' /etc/fstab || die "awk failed")

	if [[ -z ${fstabstate} ]] ; then
		einfo "Assuming you do not have a separate /boot partition."
		return 0
	fi

	local procstate=$(awk '$2 == "/boot" { split($4, a, ","); \
		for (i in a) if (a[i] ~ /^r[ow]$/) { print a[i]; break }; exit }' \
		/proc/mounts || die "awk failed")

	if [[ -z ${procstate} ]] ; then
		eerror "Your boot partition is not mounted at /boot."
		eerror "Please mount it and retry."
		die -n "/boot not mounted"
		return 1
	fi

	if [[ ${procstate} == ro ]] ; then
		eerror "Your boot partition, detected as being mounted at /boot," \
			"is read-only."
		eerror "Please remount it as read-write and retry."
		die -n "/boot mounted read-only"
		return 2
	fi

	einfo "Your boot partition was detected as being mounted at /boot."
	einfo "Files will be installed there for ${PN} to function correctly."
	return 0
}

mount-boot_pkg_pretend() {
	mount-boot_check_status
}

mount-boot_pkg_preinst() {
	mount-boot_check_status
}

mount-boot_pkg_prerm() {
	mount-boot_check_status

	if [[ -z ${EPREFIX} ]] \
		&& ! ( shopt -s failglob; : "${EROOT}"/boot/.keep* ) 2>/dev/null
	then
		# Create a .keep file, in case it is shadowed at the mount point
		touch "${EROOT}"/boot/.keep 2>/dev/null
	fi
}

# No-op phases for backwards compatibility
mount-boot_pkg_postinst() { :; }

mount-boot_pkg_postrm() { :; }

EXPORT_FUNCTIONS pkg_pretend pkg_preinst pkg_postinst pkg_prerm pkg_postrm
