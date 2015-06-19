# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/confutils.eclass,v 1.23 2012/09/15 16:16:53 zmedico Exp $

# @ECLASS: confutils.eclass
# @MAINTAINER:
# Benedikt Böhm <hollow@gentoo.org>
# @BLURB: utility functions to help with configuring a package
# @DESCRIPTION:
# The confutils eclass contains functions to handle use flag dependencies and
# extended --with-*/--enable-* magic.
#
# Based on the PHP5 eclass by Stuart Herbert <stuart@stuartherbert.com>

inherit eutils

# @VARIABLE: EBUILD_SUPPORTS_SHAREDEXT
# @DESCRIPTION:
# Set this variable to 1 if your ebuild supports shared extensions. You need to
# call confutils_init() in pkg_setup() if you use this variable.
if [[ ${EBUILD_SUPPORTS_SHAREDEXT} == 1 ]]; then
	IUSE="sharedext"
fi

# @FUNCTION: confutils_init
# @USAGE: [value]
# @DESCRIPTION:
# Call this function from your pkg_setup() function to initialize this eclass
# if EBUILD_SUPPORTS_SHAREDEXT is enabled. If no value is given `shared' is used
# by default.
confutils_init() {
	if [[ ${EBUILD_SUPPORTS_SHAREDEXT} == 1 ]] && use sharedext; then
		shared="=${1:-shared}"
	else
		shared=
	fi
}

# @FUNCTION: confutils_require_one
# @USAGE: <flag> [more flags ...]
# @DESCRIPTION:
# Use this function to ensure exactly one of the specified USE flags have been
# enabled
confutils_require_one() {
	local required_flags="$@"
	local success=0

	for flag in ${required_flags}; do
		use ${flag} && ((success++))
	done

	[[ ${success} -eq 1 ]] && return

	echo
	eerror "You *must* enable *exactly* one of the following USE flags:"
	eerror "  ${required_flags}"
	eerror
	eerror "You can do this by enabling *one* of these flag in /etc/portage/package.use:"

	set -- ${required_flags}
	eerror "     =${CATEGORY}/${PN}-${PVR} ${1}"
	shift

	for flag in $@; do
		eerror "  OR =${CATEGORY}/${PN}-${PVR} ${flag}"
	done

	echo
	die "Missing or conflicting USE flags"
}

# @FUNCTION: confutils_require_any
# @USAGE: <flag> [more flags ...]
# @DESCRIPTION:
# Use this function to ensure one or more of the specified USE flags have been
# enabled
confutils_require_any() {
	local required_flags="$@"
	local success=0

	for flag in ${required_flags}; do
		use ${flag} && success=1
	done

	[[ ${success} -eq 1 ]] && return

	echo
	eerror "You *must* enable one or more of the following USE flags:"
	eerror "  ${required_flags}"
	eerror
	eerror "You can do this by enabling these flags in /etc/portage/package.use:"
	eerror "    =${CATEGORY}/${PN}-${PVR} ${required_flags}"
	echo
	die "Missing USE flags"
}

# @FUNCTION: confutils_require_built_with_all
# @USAGE: <foreign> <flag> [more flags ...]
# @DESCRIPTION:
# Use this function to ensure all of the specified USE flags have been enabled
# in the specified foreign package
confutils_require_built_with_all() {
	local foreign=$1 && shift
	local required_flags="$@"

	built_with_use ${foreign} ${required_flags} && return

	echo
	eerror "You *must* enable all of the following USE flags in ${foreign}:"
	eerror "  ${required_flags}"
	eerror
	eerror "You can do this by enabling these flags in /etc/portage/package.use:"
	eerror "    ${foreign} ${required_flags}"
	echo
	die "Missing USE flags in ${foreign}"
}

# @FUNCTION: confutils_require_built_with_any
# @USAGE: <foreign> <flag> [more flags ...]
# @DESCRIPTION:
# Use this function to ensure one or more of the specified USE flags have been
# enabled in the specified foreign package
confutils_require_built_with_any() {
	local foreign=$1 && shift
	local required_flags="$@"
	local success=0

	for flag in ${required_flags}; do
		built_with_use ${foreign} ${flag} && success=1
	done

	[[ ${success} -eq 1 ]] && return

	echo
	eerror "You *must* enable one or more of the following USE flags in ${foreign}:"
	eerror "  ${required_flags}"
	eerror
	eerror "You can do this by enabling these flags in /etc/portage/package.use:"
	eerror "    ${foreign} ${required_flags}"
	echo
	die "Missing USE flags in ${foreign}"
}

# @FUNCTION: confutils_use_conflict
# @USAGE: <enabled flag> <conflicting flag> [more conflicting flags ...]
# @DESCRIPTION:
# Use this function to automatically complain to the user if conflicting USE
# flags have been enabled
confutils_use_conflict() {
	use $1 || return

	local my_flag="$1" && shift
	local my_present=
	local my_remove=

	for flag in "$@"; do
		if use ${flag}; then
			my_present="${my_present} ${flag}"
			my_remove="${my_remove} -${flag}"
		fi
	done

	[[ -z "${my_present}" ]] && return

	echo
	eerror "USE flag '${my_flag}' conflicts with these USE flag(s):"
	eerror "  ${my_present}"
	eerror
	eerror "You must disable these conflicting flags before you can emerge this package."
	eerror "You can do this by disabling these flags in /etc/portage/package.use:"
	eerror "    =${CATEGORY}/${PN}-${PVR} ${my_remove}"
	eerror
	eerror "You could disable this flag instead in /etc/portage/package.use:"
	eerror "    =${CATEGORY}/${PN}-${PVR} -${my_flag}"
	echo
	die "Conflicting USE flags"
}

# @FUNCTION: confutils_use_depend_all
# @USAGE: <enabled flag> <needed flag> [more needed flags ...]
# @DESCRIPTION:
# Use this function to automatically complain to the user if a USE flag depends
# on another USE flag that hasn't been enabled
confutils_use_depend_all() {
	use $1 || return

	local my_flag="$1" && shift
	local my_missing=

	for flag in "$@"; do
		use ${flag} || my_missing="${my_missing} ${flag}"
	done

	[[ -z "${my_missing}" ]] && return

	echo
	eerror "USE flag '${my_flag}' needs these additional flag(s) set:"
	eerror "  ${my_missing}"
	eerror
	eerror "You can do this by enabling these flags in /etc/portage/package.use:"
	eerror "    =${CATEGORY}/${PN}-${PVR} ${my_missing}"
	eerror
	eerror "You could disable this flag instead in /etc/portage/package.use:"
	eerror "    =${CATEGORY}/${PN}-${PVR} -${my_flag}"
	echo
	die "Need missing USE flags"
}

# @FUNCTION: confutils_use_depend_any
# @USAGE: <enabled flag> <needed flag> [more needed flags ...]
# @DESCRIPTION:
# Use this function to automatically complain to the user if a USE flag depends
# on another USE flag that hasn't been enabled
confutils_use_depend_any() {
	use $1 || return

	local my_flag="$1" && shift
	local my_found=
	local my_missing=

	for flag in "$@"; do
		if use ${flag}; then
			my_found="${my_found} ${flag}"
		else
			my_missing="${my_missing} ${flag}"
		fi
	done

	[[ -n "${my_found}" ]] && return

	echo
	eerror "USE flag '${my_flag}' needs one or more of these additional flag(s) set:"
	eerror "  ${my_missing}"
	eerror
	eerror "You can do this by enabling one of these flags in /etc/portage/package.use:"
	eerror "    =${CATEGORY}/${PN}-${PVR} ${my_missing}"
	eerror
	eerror "You could disable this flag instead in /etc/portage/package.use:"
	eerror "    =${CATEGORY}/${PN}-${PVR} -${my_flag}"
	echo
	die "Need missing USE flag(s)"
}

# @FUNCTION: confutils_use_depend_built_with_all
# @USAGE: <enabled flag> <foreign> <needed flag> [more needed flags ...]
# @DESCRIPTION:
# Use this function to automatically complain to the user if a USE flag depends
# on a USE flag in another package that hasn't been enabled
confutils_use_depend_built_with_all() {
	use $1 || return

	local my_flag="$1" && shift
	local foreign=$1 && shift
	local required_flags="$@"

	built_with_use ${foreign} ${required_flags} && return

	echo
	eerror "USE flag '${my_flag}' needs the following USE flags in ${foreign}:"
	eerror "  ${required_flags}"
	eerror
	eerror "You can do this by enabling these flags in /etc/portage/package.use:"
	eerror "    ${foreign} ${required_flags}"
	eerror
	eerror "You could disable this flag instead in /etc/portage/package.use:"
	eerror "    =${CATEGORY}/${PN}-${PVR} -${my_flag}"
	echo
	die "Missing USE flags in ${foreign}"
}

# @FUNCTION: confutils_use_depend_built_with_any
# @USAGE: <enabled flag> <foreign> <needed flag> [more needed flags ...]
# @DESCRIPTION:
# Use this function to automatically complain to the user if a USE flag depends
# on a USE flag in another package that hasn't been enabled
confutils_use_depend_built_with_any() {
	use $1 || return

	local my_flag="$1" && shift
	local foreign=$1 && shift
	local required_flags="$@"
	local success=0

	for flag in ${required_flags}; do
		built_with_use ${foreign} ${flag} && success=1
	done

	[[ ${success} -eq 1 ]] && return

	echo
	eerror "USE flag '${my_flag}' needs one or more of the following USE flags in ${foreign}:"
	eerror "  ${required_flags}"
	eerror
	eerror "You can do this by enabling these flags in /etc/portage/package.use:"
	eerror "    ${foreign} ${required_flags}"
	eerror
	eerror "You could disable this flag instead in /etc/portage/package.use:"
	eerror "    =${CATEGORY}/${PN}-${PVR} -${my_flag}"
	echo
	die "Missing USE flags in ${foreign}"
}


# internal function constructs the configure values for optional shared module
# support and extra arguments
_confutils_shared_suffix() {
	local my_shared=

	if [[ "$1" == "1" ]]; then
		if [[ -n "${shared}" ]]; then
			my_shared="${shared}"
			if [[ -n "$2" ]]; then
				my_shared="${my_shared},$2"
			fi
		elif [[ -n "$2" ]]; then
			my_shared="=$2"
		fi
	else
		if [[ -n "$2" ]]; then
			my_shared="=$2"
		fi
	fi

	echo "${my_shared}"
}

# @FUNCTION: enable_extension_disable
# @USAGE: <extension> <flag> [msg]
# @DESCRIPTION:
# Use this function to disable an extension that is enabled by default.  This is
# provided for those rare configure scripts that don't support a --enable for
# the corresponding --disable.
enable_extension_disable() {
	local my_msg=${3:-$1}

	if use "$2" ; then
		einfo "  Enabling ${my_msg}"
	else
		my_conf="${my_conf} --disable-$1"
		einfo "  Disabling ${my_msg}"
	fi
}

# @FUNCTION: enable_extension_enable
# @USAGE: <extension> <flag> [shared] [extra conf] [msg]
# @DESCRIPTION:
# This function is like use_enable(), except that it knows about enabling
# modules as shared libraries, and it supports passing additional data with the
# switch.
enable_extension_enable() {
	local my_shared=$(_confutils_shared_suffix $3 $4)
	local my_msg=${5:-$1}

	if use $2; then
		my_conf="${my_conf} --enable-${1}${my_shared}"
		einfo "  Enabling ${my_msg}"
	else
		my_conf="${my_conf} --disable-$1"
		einfo "  Disabling ${my_msg}"
	fi
}

# @FUNCTION: enable_extension_enableonly
# @USAGE: <extension> <flag> [shared] [extra conf] [msg]
# @DESCRIPTION:
# This function is like use_enable(), except that it knows about enabling
# modules as shared libraries, and it supports passing additional data with the
# switch.  This function is provided for those rare configure scripts that support
# --enable but not the corresponding --disable.
enable_extension_enableonly() {
	local my_shared=$(_confutils_shared_suffix $3 $4)
	local my_msg=${5:-$1}

	if use $2 ; then
		my_conf="${my_conf} --enable-${1}${my_shared}"
		einfo "  Enabling ${my_msg}"
	else
		# note: we deliberately do *not* use a --disable switch here
		einfo "  Disabling ${my_msg}"
	fi
}

# @FUNCTION: enable_extension_without
# @USAGE: <extension> <flag> [msg]
# @DESCRIPTION:
# Use this function to disable an extension that is enabled by default. This
# function is provided for those rare configure scripts that support --without
# but not the corresponding --with
enable_extension_without() {
	local my_msg=${3:-$1}

	if use "$2"; then
		einfo "  Enabling ${my_msg}"
	else
		my_conf="${my_conf} --without-$1"
		einfo "  Disabling ${my_msg}"
	fi
}

# @FUNCTION: enable_extension_with
# @USAGE: <extension> <flag> [shared] [extra conf] [msg]
# @DESCRIPTION:
# This function is like use_with(), except that it knows about enabling modules
# as shared libraries, and it supports passing additional data with the switch.
enable_extension_with() {
	local my_shared=$(_confutils_shared_suffix $3 $4)
	local my_msg=${5:-$1}

	if use $2; then
		my_conf="${my_conf} --with-${1}${my_shared}"
		einfo "  Enabling ${my_msg}"
	else
		my_conf="${my_conf} --without-$1"
		einfo "  Disabling ${my_msg}"
	fi
}

# @FUNCTION: enable_extension_withonly
# @USAGE: <extension> <flag> [shared] [extra conf] [msg]
# @DESCRIPTION:
# This function is like use_with(), except that it knows about enabling modules
# as shared libraries, and it supports passing additional data with the switch.
# This function is provided for those rare configure scripts that support --enable
# but not the corresponding --disable.
enable_extension_withonly() {
	local my_shared=$(_confutils_shared_suffix $3 $4)
	local my_msg=${5:-$1}

	if use $2; then
		my_conf="${my_conf} --with-${1}${my_shared}"
		einfo "  Enabling ${my_msg}"
	else
		# note: we deliberately do *not* use a --without switch here
		einfo "  Disabling ${my_msg}"
	fi
}

# @FUNCTION: enable_extension_enable_built_with
# @USAGE: <foreign> <flag> <extension> [shared] [extra conf] [msg]
# @DESCRIPTION:
# This function is like enable_extension_enable(), except that it
# enables/disables modules based on a USE flag in a foreign package.
enable_extension_enable_built_with() {
	local my_shared=$(_confutils_shared_suffix $4 $5)
	local my_msg=${6:-$3}

	if built_with_use $1 $2; then
		my_conf="${my_conf} --enable-${3}${my_shared}"
		einfo "  Enabling ${my_msg}"
	else
		my_conf="${my_conf} --disable-$3"
		einfo "  Disabling ${my_msg}"
	fi
}

# @FUNCTION: enable_extension_with_built_with ()
# @USAGE: <foreign> <flag> <extension> [shared] [extra conf] [msg]
# @DESCRIPTION:
# This function is like enable_extension_with(), except that it
# enables/disables modules based on a USE flag in a foreign package.
enable_extension_with_built_with() {
	# legacy workaround
	if [[ "$4" != "0" && "$4" != "1" ]]; then
		enable_extension_with_built_with "$1" "$2" "$3" 0 "$4" "$5"
		return
	fi

	local my_shared=$(_confutils_shared_suffix $4 $5)
	local my_msg=${6:-$3}

	if built_with_use $1 $2; then
		my_conf="${my_conf} --with-${3}${my_shared}"
		einfo "  Enabling ${my_msg}"
	else
		my_conf="${my_conf} --disable-$3"
		einfo "  Disabling ${my_msg}"
	fi
}
