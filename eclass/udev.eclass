# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/udev.eclass,v 1.14 2014/07/30 20:00:19 ssuominen Exp $

# @ECLASS: udev.eclass
# @MAINTAINER:
# udev-bugs@gentoo.org
# @BLURB: Default eclass for determining udev directories.
# @DESCRIPTION:
# Default eclass for determining udev directories.
# @EXAMPLE:
#
# @CODE
# inherit udev
#
# # Example of the eclass usage:
# RDEPEND="virtual/udev"
# DEPEND="${RDEPEND}"
#
# src_configure() {
#	econf --with-rulesdir="$(get_udevdir)"/rules.d
# }
#
# src_install() {
#	default
#	# udev_dorules contrib/99-foomatic
#	# udev_newrules contrib/98-foomatic 99-foomatic
# }
# @CODE

inherit toolchain-funcs

case ${EAPI:-0} in
	0|1|2|3|4|5) ;;
	*) die "${ECLASS}.eclass API in EAPI ${EAPI} not yet established."
esac

RDEPEND=""
DEPEND="virtual/pkgconfig"

# @FUNCTION: _udev_get_udevdir
# @INTERNAL
# @DESCRIPTION:
# Get unprefixed udevdir.
_udev_get_udevdir() {
	if $($(tc-getPKG_CONFIG) --exists udev); then
		echo "$($(tc-getPKG_CONFIG) --variable=udevdir udev)"
	else
		echo /lib/udev
	fi
}

# @FUNCTION: udev_get_udevdir
# @DESCRIPTION:
# Use the short version $(get_udevdir) instead!
udev_get_udevdir() {
	debug-print-function ${FUNCNAME} "${@}"

	eerror "This ebuild should be using the get_udevdir() function instead of the deprecated udev_get_udevdir()"
	die "Deprecated function call: udev_get_udevdir(), please report to (overlay) maintainers."
}

# @FUNCTION: get_udevdir
# @DESCRIPTION:
# Output the path for the udev directory (not including ${D}).
# This function always succeeds, even if udev is not installed.
# The fallback value is set to /lib/udev
get_udevdir() {
	debug-print-function ${FUNCNAME} "${@}"

	echo "$(_udev_get_udevdir)"
}

# @FUNCTION: udev_dorules
# @USAGE: rules [...]
# @DESCRIPTION:
# Install udev rule(s). Uses doins, thus it is fatal in EAPI 4
# and non-fatal in earlier EAPIs.
udev_dorules() {
	debug-print-function ${FUNCNAME} "${@}"

	(
		insinto "$(_udev_get_udevdir)"/rules.d
		doins "${@}"
	)
}

# @FUNCTION: udev_newrules
# @USAGE: oldname newname
# @DESCRIPTION:
# Install udev rule with a new name. Uses newins, thus it is fatal
# in EAPI 4 and non-fatal in earlier EAPIs.
udev_newrules() {
	debug-print-function ${FUNCNAME} "${@}"

	(
		insinto "$(_udev_get_udevdir)"/rules.d
		newins "${@}"
	)
}

# @FUNCTION: udev_reload
# @DESCRIPTION:
# Run udevadm control --reload to refresh rules and databases
udev_reload() {
	if [[ ${ROOT} != "" ]] && [[ ${ROOT} != "/" ]]; then
		return 0
	fi

	if [[ -d ${ROOT}/run/udev ]]; then
		ebegin "Running udev control --reload for reloading rules and databases"
		udevadm control --reload
		eend $?
	fi
}
