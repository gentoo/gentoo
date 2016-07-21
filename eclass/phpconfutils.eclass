# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: phpconfutils.eclass
# @MAINTAINER:
# Gentoo PHP team <php-bugs@gentoo.org>
# @AUTHOR:
# Based on Stuart's work on the original confutils eclass
# Luca Longinotti <chtekk@gentoo.org>
# @BLURB: Provides utility functions to help with configuring PHP.
# @DESCRIPTION:
# This eclass provides utility functions to help with configuring PHP.
# It is only used by other php eclasses currently and the functions
# are not generally intended for direct use in ebuilds.


# ========================================================================
# List of USE flags that need deps that aren't yet in Portage
# or that can't be (fex. certain commercial apps)
#
# You must define PHPCONFUTILS_MISSING_DEPS if you need this

# ========================================================================
# phpconfutils_sort_flags()
#
# Sort and remove duplicates of the auto-enabled USE flags
#

phpconfutils_sort_flags() {
	# Sort the list of auto-magically enabled USE flags
	PHPCONFUTILS_AUTO_USE="$(echo ${PHPCONFUTILS_AUTO_USE} | tr '\040\010' '\012\012' | sort -u)"
}

# ========================================================================
# phpconfutils_init()
#
# Call this function from your src_compile() function to initialise
# this eclass first
#

phpconfutils_init() {
	# Define wheter we shall support shared extensions or not
	if use "sharedext" ; then
		shared="=shared"
	else
		shared=""
	fi

	phpconfutils_sort_flags
}

# ========================================================================
# phpconfutils_usecheck()
#
# Check if the USE flag we want enabled is part of the auto-magical ones
#

phpconfutils_usecheck() {
	local x
	local use="$1"

	for x in ${PHPCONFUTILS_AUTO_USE} ; do
		if [[ "${use}+" == "${x}+" ]] ; then
			return 0
		fi
	done

	# If we get here, the USE is not among the auto-enabled ones
	return 1
}

# ========================================================================
# phpconfutils_require_any()
#
# Use this function to ensure one or more of the specified USE flags have
# been enabled and output the results
#
# $1    - message to output everytime a flag is found
# $2    - message to output everytime a flag is not found
# $3 .. - flags to check
#

phpconfutils_require_any() {
	local success_msg="$1"
	shift
	local fail_msg="$1"
	shift

	local required_flags="$@"
	local default_flag="$1"
	local success="0"

	while [[ -n "$1" ]] ; do
		if use "$1" ; then
			einfo "${success_msg} $1"
			success="1"
		else
			einfo "${fail_msg} $1"
		fi
		shift
	done

	# Did we find what we are looking for?
	if [[ "${success}" == "1" ]] ; then
		return
	fi

	# If we get here, then none of the required USE flags were enabled
	eerror
	eerror "You should enable one or more of the following USE flags:"
	eerror "  ${required_flags}"
	eerror
	eerror "You can do this by enabling these flags in /etc/portage/package.use:"
	eerror "    =${CATEGORY}/${PN}-${PVR} ${required_flags}"
	eerror
	eerror "The ${default_flag} USE flag was automatically enabled now."
	eerror
	PHPCONFUTILS_AUTO_USE="${PHPCONFUTILS_AUTO_USE} ${default_flag}"
}

# ========================================================================
# phpconfutils_use_conflict()
#
# Use this function to automatically complain to the user if USE flags
# that directly conflict have been enabled
#
# $1	- flag that conflicts with other flags
# $2 .. - flags that conflict
#

phpconfutils_use_conflict() {
	phpconfutils_sort_flags

	if ! use "$1" && ! phpconfutils_usecheck "$1" ; then
		return
	fi

	local my_flag="$1"
	shift

	local my_present=""
	local my_remove=""

	while [[ "$1+" != "+" ]] ; do
		if use "$1" || phpconfutils_usecheck "$1" ; then
			my_present="${my_present} $1"
			my_remove="${my_remove} -$1"
		fi
		shift
	done

	if [[ -n "${my_present}" ]] ; then
		eerror
		eerror "USE flag '${my_flag}' conflicts with these USE flag(s):"
		eerror "  ${my_present}"
		eerror
		eerror "You must disable these conflicting flags before you can emerge this package."
		eerror "You can do this by disabling these flags in /etc/portage/package.use:"
		eerror "    =${CATEGORY}/${PN}-${PVR} ${my_remove}"
		eerror
		die "Conflicting USE flags found"
	fi
}

# ========================================================================
# phpconfutils_use_depend_all()
#
# Use this function to specify USE flags that depend on eachother,
# they will be automatically enabled and used for checks later
#
# $1	- flag that depends on other flags
# $2 .. - the flags that must be set for $1 to be valid
#

phpconfutils_use_depend_all() {
	phpconfutils_sort_flags

	if ! use "$1" && ! phpconfutils_usecheck "$1" ; then
		return
	fi

	local my_flag="$1"
	shift

	local my_missing=""

	while [[ "$1+" != "+" ]] ; do
		if ! use "$1" && ! phpconfutils_usecheck "$1" ; then
			my_missing="${my_missing} $1"
		fi
		shift
	done

	if [[ -n "${my_missing}" ]] ; then
		PHPCONFUTILS_AUTO_USE="${PHPCONFUTILS_AUTO_USE} ${my_missing}"
		ewarn
		ewarn "USE flag '${my_flag}' needs these additional flag(s) set:"
		ewarn "  ${my_missing}"
		ewarn
		ewarn "'${my_missing}' was automatically enabled and the required extensions will be"
		ewarn "built. In any case it is recommended to enable those flags for"
		ewarn "future reference, by adding the following to /etc/portage/package.use:"
		ewarn "    =${CATEGORY}/${PN}-${PVR} ${my_missing}"
		ewarn
	fi
}

# ========================================================================
# phpconfutils_use_depend_any()
#
# Use this function to automatically complain to the user if a USE flag
# depends on another USE flag that hasn't been enabled
#
# $1	- flag that depends on other flags
# $2	- flag that is used as default if none is enabled
# $3 .. - flags that must be set for $1 to be valid
#

phpconfutils_use_depend_any() {
	phpconfutils_sort_flags

	if ! use "$1" && ! phpconfutils_usecheck "$1" ; then
		return
	fi

	local my_flag="$1"
	shift

	local my_default_flag="$1"
	shift

	local my_found=""
	local my_missing=""

	while [[ "$1+" != "+" ]] ; do
		if use "$1" || phpconfutils_usecheck "$1" ; then
			my_found="${my_found} $1"
		else
			my_missing="${my_missing} $1"
		fi
		shift
	done

	if [[ -z "${my_found}" ]] ; then
		PHPCONFUTILS_AUTO_USE="${PHPCONFUTILS_AUTO_USE} ${my_default_flag}"
		ewarn
		ewarn "USE flag '${my_flag}' needs one of these additional flag(s) set:"
		ewarn "  ${my_missing}"
		ewarn
		ewarn "'${my_default_flag}' was automatically selected and enabled."
		ewarn "You can change that by enabling/disabling those flags accordingly"
		ewarn "in /etc/portage/package.use."
		ewarn
	fi
}

# ========================================================================
# phpconfutils_extension_disable()
#
# Use this function to disable an extension that is enabled by default.
# This is provided for those rare configure scripts that don't support
# a --enable for the corresponding --disable
#
# $1	- extension name
# $2	- USE flag
# $3	- optional message to einfo() to the user
#

phpconfutils_extension_disable() {
	if ! use "$2" && ! phpconfutils_usecheck "$2" ; then
		my_conf="${my_conf} --disable-$1"
		[[ -n "$3" ]] && einfo "  Disabling $1"
	else
		[[ -n "$3" ]] && einfo "  Enabling $1"
	fi
}

# ========================================================================
# phpconfutils_extension_enable()
#
# This function is like use_enable(), except that it knows about
# enabling modules as shared libraries, and it supports passing
# additional data with the switch
#
# $1	- extension name
# $2	- USE flag
# $3	- 1 = support shared, 0 = never support shared
# $4	- additional setting for configure
# $5	- additional message to einfo out to the user
#

phpconfutils_extension_enable() {
	local my_shared

	if [[ "$3" == "1" ]] ; then
		if [[ "${shared}+" != "+" ]] ; then
			my_shared="${shared}"
			if [[ "$4+" != "+" ]] ; then
				my_shared="${my_shared},$4"
			fi
		elif [[ "$4+" != "+" ]] ; then
			my_shared="=$4"
		fi
	else
		if [[ "$4+" != "+" ]] ; then
			my_shared="=$4"
		fi
	fi

	if use "$2" || phpconfutils_usecheck "$2" ; then
		my_conf="${my_conf} --enable-$1${my_shared}"
		einfo "  Enabling $1"
	else
		my_conf="${my_conf} --disable-$1"
		einfo "  Disabling $1"
	fi
}

# ========================================================================
# phpconfutils_extension_without()
#
# Use this function to disable an extension that is enabled by default
# This function is provided for those rare configure scripts that support
# --without but not the corresponding --with
#
# $1	- extension name
# $2	- USE flag
# $3	- optional message to einfo() to the user
#

phpconfutils_extension_without() {
	if ! use "$2" && ! phpconfutils_usecheck "$2" ; then
		my_conf="${my_conf} --without-$1"
		einfo "  Disabling $1"
	else
		einfo "  Enabling $1"
	fi
}

# ========================================================================
# phpconfutils_extension_with()
#
# This function is a replacement for use_with.  It supports building
# extensions as shared libraries,
#
# $1	- extension name
# $2	- USE flag
# $3	- 1 = support shared, 0 = never support shared
# $4	- additional setting for configure
# $5	- optional message to einfo() out to the user
#

phpconfutils_extension_with() {
	local my_shared

	if [[ "$3" == "1" ]] ; then
		if [[ "${shared}+" != "+" ]] ; then
			my_shared="${shared}"
			if [[ "$4+" != "+" ]] ; then
				my_shared="${my_shared},$4"
			fi
		elif [[ "$4+" != "+" ]] ; then
			my_shared="=$4"
		fi
	else
		if [[ "$4+" != "+" ]] ; then
			my_shared="=$4"
		fi
	fi

	if use "$2" || phpconfutils_usecheck "$2" ; then
		my_conf="${my_conf} --with-$1${my_shared}"
		einfo "  Enabling $1"
	else
		my_conf="${my_conf} --without-$1"
		einfo "  Disabling $1"
	fi
}

# ========================================================================
# phpconfutils_warn_about_external_deps()
#
# This will output a warning to the user if he enables commercial or other
# software not currently present in Portage
#

phpconfutils_warn_about_external_deps() {
	phpconfutils_sort_flags

	local x
	local my_found="0"

	for x in ${PHPCONFUTILS_MISSING_DEPS} ; do
		if use "${x}" || phpconfutils_usecheck "${x}" ; then
			ewarn "USE flag ${x} enables support for software not present in Portage!"
			my_found="1"
		fi
	done

	if [[ "${my_found}" == "1" ]] ; then
		ewarn
		ewarn "This ebuild will continue, but if you haven't already installed the"
		ewarn "software required to satisfy the list above, this package will probably"
		ewarn "fail to compile later on."
		ewarn "*DO NOT* file bugs about compile failures or issues you're having"
		ewarn "when using one of those flags, as we aren't able to support them."
		ewarn "|=|=|=|=|=|=| You are on your own if you use them! |=|=|=|=|=|=|"
		ewarn
		ebeep 5
	fi
}

# ========================================================================
# phpconfutils_built_with_use()
#
# Sobstitute for built_with_use() to support the magically enabled USE flags
#

phpconfutils_built_with_use() {
	local opt="$1"
	[[ ${opt:0:1} = "-" ]] && shift || opt="-a"

	local PHP_PKG=$(best_version $1)
	shift

	local PHP_USEFILE="${ROOT}/var/lib/php-pkg/${PHP_PKG}/PHP_USEFILE"

	[[ ! -e "${PHP_USEFILE}" ]] && return 0

	local PHP_USE_BUILT=$(<${PHP_USEFILE})
	while [[ $# -gt 0 ]] ; do
		if [[ ${opt} = "-o" ]] ; then
			has $1 ${PHP_USE_BUILT} && return 0
		else
			has $1 ${PHP_USE_BUILT} || return 1
		fi
		shift
	done
	[[ ${opt} = "-a" ]]
}

# ========================================================================
# phpconfutils_generate_usefile()
#
# Generate the file used by phpconfutils_built_with_use() to check it's
# USE flags
#

phpconfutils_generate_usefile() {
	phpconfutils_sort_flags

	local PHP_USEFILE="${D}/var/lib/php-pkg/${CATEGORY}/${PN}-${PVR}/PHP_USEFILE"

	# Write the auto-enabled USEs into the correct file
	dodir "/var/lib/php-pkg/${CATEGORY}/${PN}-${PVR}/"
	echo "${PHPCONFUTILS_AUTO_USE}" > "${PHP_USEFILE}"
}
