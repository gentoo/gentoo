# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: udev.eclass
# @MAINTAINER:
# systemd@gentoo.org
# @SUPPORTED_EAPIS: 5 6 7 8
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
#
# pkg_postinst() {
#	udev_reload
# }
#
# pkg_postrm() {
#	udev_reload
# }
# @CODE

case ${EAPI} in
	5|6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_UDEV_ECLASS} ]]; then
_UDEV_ECLASS=1

inherit toolchain-funcs

if [[ ${EAPI} == [56] ]]; then
	DEPEND="virtual/pkgconfig"
else
	BDEPEND="virtual/pkgconfig"
fi

# @FUNCTION: _udev_get_udevdir
# @INTERNAL
# @DESCRIPTION:
# Get unprefixed udevdir.
_udev_get_udevdir() {
	# https://github.com/pkgconf/pkgconf/issues/205
	local -x PKG_CONFIG_FDO_SYSROOT_RULES=1
	if $($(tc-getPKG_CONFIG) --exists udev); then
		local udevdir="$($(tc-getPKG_CONFIG) --variable=udevdir udev)"
		echo "${udevdir#${EPREFIX}}"
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
# @USAGE: <rule> [...]
# @DESCRIPTION:
# Install udev rule(s). Uses doins, thus it is fatal.
udev_dorules() {
	debug-print-function ${FUNCNAME} "${@}"

	(
		insopts -m 0644
		insinto "$(_udev_get_udevdir)"/rules.d
		doins "${@}"
	)
}

# @FUNCTION: udev_newrules
# @USAGE: <oldname> <newname>
# @DESCRIPTION:
# Install udev rule with a new name. Uses newins, thus it is fatal.
udev_newrules() {
	debug-print-function ${FUNCNAME} "${@}"

	(
		insopts -m 0644
		insinto "$(_udev_get_udevdir)"/rules.d
		newins "${@}"
	)
}

# @FUNCTION: udev_reload
# @DESCRIPTION:
# Run "udevadm control --reload" to refresh rules and databases.
# Should be called from pkg_postinst and pkg_postrm in packages which install
# udev rules or hwdb data.
udev_reload() {
	if [[ -n ${ROOT%/} ]]; then
		return 0
	fi

	if [[ -d ${ROOT}/run/udev ]]; then
		ebegin "Running udev control --reload for reloading rules and databases"
		udevadm control --reload
		eend $?
	fi
}

fi
