# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: mount-boot-utils.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: functions for packages that install files into /boot or the ESP
# @DESCRIPTION:
# This eclass is really only useful for bootloaders and kernel installation.
#
# If the live system has a separate /boot partition or ESP configured, then this
# function tries to ensure that it's mounted in rw mode, exiting with an error
# if it can't.  It does nothing if /boot and ESP isn't a separate partition.
#
# This eclass provides the functions used by mount-boot.eclass in an "inherit-
# safe" way. This allows these functions to be used in other eclasses cleanly.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: mount-boot_is_disabled
# @INTERNAL
# @DESCRIPTION:
# Detect whether the current environment/build settings are such that we do not
# want to mess with any mounts.
mount-boot_is_disabled() {
	# Since this eclass only deals with /boot, skip things when EROOT is active.
	if [[ -n ${EROOT} ]]; then
		return 0
	fi

	# If we're only building a package, then there's no need to check things.
	if [[ ${MERGE_TYPE} == buildonly ]]; then
		return 0
	fi

	# The user wants us to leave things be.
	if [[ -n ${DONT_MOUNT_BOOT} ]]; then
		return 0
	fi

	# OK, we want to handle things ourselves.
	return 1
}

# @FUNCTION: mount-boot_check_status
# @INTERNAL
# @DESCRIPTION:
# Check if /boot and ESP is sane, i.e., mounted as read-write if on a separate
# partition.  Die if conditions are not fulfilled.  If nonfatal is used,
# the function will return a non-zero status instead.
mount-boot_check_status() {
	# Get out fast if possible.
	mount-boot_is_disabled && return 0

	local partition=
	local part_is_not_mounted=
	local part_is_read_only=
	local candidates=( /boot )

	# If system is booted with UEFI, check for ESP as well
	if [[ -d /sys/firmware/efi ]]; then
		# Use same candidates for ESP as installkernel and eclean-kernel
		candidates+=( /efi /boot/efi /boot/EFI )
	fi

	for partition in ${candidates[@]}; do
		# note that /dev/BOOT is in the Gentoo default /etc/fstab file
		local fstabstate=$(awk "!/^[[:blank:]]*#|^\/dev\/BOOT/ && \$2 == \"${partition}\" \
			{ print 1; exit }" /etc/fstab || die "awk failed")

		if [[ -z ${fstabstate} ]]; then
			einfo "Assuming you do not have a separate ${partition} partition."
		else
			local procstate=$(awk "\$2 == \"${partition}\" { split(\$4, a, \",\"); \
				for (i in a) if (a[i] ~ /^r[ow]\$/) { print a[i]; break }; exit }" \
				/proc/mounts || die "awk failed")

			if [[ -z ${procstate} ]]; then
				eerror "Your ${partition} partition is not mounted"
				eerror "Please mount it and retry."
				die -n "${partition} not mounted"
				part_is_not_mounted=1
			else
				if [[ ${procstate} == ro ]]; then
					eerror "Your ${partition} partition, was detected as being mounted," \
						"but is mounted read-only."
					eerror "Please remount it as read-write and retry."
					die -n "${partition} mounted read-only"
					part_is_read_only=1
				else
					einfo "Your ${partition} partition was detected as being mounted."
					einfo "Files will be installed there for ${PN} to function correctly."
				fi
			fi
		fi
	done

	if [[ -n ${part_is_not_mounted} ]]; then
		return 1
	elif [[ -n ${part_is_read_only} ]]; then
		return 2
	else
		return 0
	fi
}
