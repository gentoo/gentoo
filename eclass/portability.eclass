# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: portability.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @AUTHOR:
# Diego Pettenò <flameeyes@gentoo.org>
# @BLURB: This eclass is created to avoid using non-portable GNUisms inside ebuilds

if [[ -z ${_PORTABILITY_ECLASS} ]]; then
_PORTABILITY_ECLASS=1

# @FUNCTION: treecopy
# @USAGE: <orig1> [orig2 orig3 ....] <dest>
# @RETURN:
# @DESCRIPTION:
# mimic cp --parents copy, but working on BSD userland as well
treecopy() {
	local dest=${!#}
	local files_count=$#

	while (( $# > 1 )); do
		local dirstruct=$(dirname "$1")
		mkdir -p "${dest}/${dirstruct}" || die
		cp -pPR "$1" "${dest}/${dirstruct}" || die

		shift
	done
}

# @FUNCTION: seq
# @USAGE: [min] <max> [step]
# @RETURN: sequence from min to max regardless of seq command being present on system
# @DESCRIPTION:
# compatibility function that mimes seq command if not available
seq() {
	# First try `seq`
	local p=$(type -P seq)
	if [[ -n ${p} ]] ; then
		"${p}" "$@" || die
		return $?
	fi

	local min max step
	case $# in
		1) min=1  max=$1 step=1  ;;
		2) min=$1 max=$2 step=1  ;;
		3) min=$1 max=$3 step=$2 ;;
		*) die "seq called with wrong number of arguments" ;;
	esac

	# Then try `jot`
	p=$(type -P jot)
	if [[ -n ${p} ]] ; then
		local reps
		# BSD userland
		if [[ ${step} != 0 ]] ; then
			reps=$(( (max - min) / step + 1 ))
		else
			reps=0
		fi

		jot $reps $min $max $step || die
		return $?
	fi

	# Screw it, do the output ourselves
	while :; do
		[[ $max < $min && $step > 0 ]] && break
		[[ $min < $max && $step < 0 ]] && break
		echo $min
		: $(( min += step ))
	done
	return 0
}

# @FUNCTION: dlopen_lib
# @USAGE:
# @RETURN: linker flag if needed
# @DESCRIPTION:
# Gets the linker flag to link to dlopen() function
dlopen_lib() {
	# - Solaris needs nothing
	# - Darwin needs nothing
	# - *BSD needs nothing
	# - Linux needs -ldl (glibc and uclibc)
	# - Interix needs -ldl
	case "${CHOST}" in
		*-linux-gnu*|*-linux-uclibc|*-interix*)
			echo "-ldl"
		;;
	esac
}

# @FUNCTION: get_bmake
# @USAGE:
# @RETURN: system version of make
# @DESCRIPTION:
# Gets the name of the BSD-ish make command (bmake from NetBSD)
#
# This will return make (provided by system packages) for BSD userlands,
# or bsdmake for Darwin userlands and pmake for the rest of userlands,
# both of which are provided by sys-devel/pmake package.
#
# Note: the bsdmake for Darwin userland is with compatibility with MacOSX
# default name.
get_bmake() {
	if [[ ${CBUILD:-${CHOST}} == *bsd* ]]; then
		echo make
	elif [[ ${CBUILD:-${CHOST}} == *darwin* ]]; then
		echo bsdmake
	else
		echo bmake
	fi
}

# @FUNCTION: get_mounts
# @USAGE:
# @RETURN: table of mounts in form "point node fs opts"
# @MAINTAINER:
# @DESCRIPTION:
# Portable method of getting mount names and points.
# Returns as "point node fs options"
# Remember to convert 040 back to a space.
get_mounts() {
	local point= node= fs= opts= foo=

	# Linux has /proc/mounts which should always exist
	if [[ $(uname -s) == "Linux" ]] ; then
		while read node point fs opts foo ; do
			echo "${point} ${node} ${fs} ${opts}"
		done < /proc/mounts
		return
	fi

	# OK, pray we have a -p option that outputs mounts in fstab format
	# using tabs as the seperator.
	# Then pray that there are no tabs in the either.
	# Currently only FreeBSD supports this and the other BSDs will
	# have to be patched.
	# Athough the BSD's may support /proc, they do NOT put \040 in place
	# of the spaces and we should not force a /proc either.
	local IFS=$'\t'
	LC_ALL=C mount -p | while read node point fs foo ; do
		opts=${fs#* }
		fs=${fs%% *}
		echo "${point// /\040} ${node// /\040} ${fs%% *} ${opts// /\040}"
	done
}

_dead_portability_user_funcs() { die "if you really need this, please file a bug for base-system@gentoo.org"; }
is-login-disabled() { _dead_portability_user_funcs; }

fi
