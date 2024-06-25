# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: mount-boot.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: eclass for packages that install files into /boot or the ESP
# @DESCRIPTION:
# This eclass is really only useful for bootloaders and kernel installation.
#
# If the live system has a separate /boot partition or ESP configured, then this
# function tries to ensure that it's mounted in rw mode, exiting with an error
# if it can't.  It does nothing if /boot and ESP isn't a separate partition.
#
# This eclass exports the functions provided by mount-boot-utils.eclass to
# the pkg_pretend and pkg_{pre,post}{inst,rm} phases.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit mount-boot-utils

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
