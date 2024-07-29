# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ninja-utils.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# Mike Gilbert <floppym@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: common bits to run app-alternatives/ninja builder
# @DESCRIPTION:
# This eclass provides a single function -- eninja -- that can be used
# to run the ninja builder alike emake. It does not define any
# dependencies, you need to depend on app-alternatives/ninja yourself. Since
# ninja is rarely used stand-alone, most of the time this eclass will
# be used indirectly by the eclasses for other build systems (CMake,
# Meson).

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_NINJA_UTILS_ECLASS} ]]; then
_NINJA_UTILS_ECLASS=1

# @ECLASS_VARIABLE: NINJA
# @PRE_INHERIT
# @DESCRIPTION:
# Specify a compatible ninja implementation to be used by eninja().
# At this point only "ninja" and "samu" are explicitly supported,
# but other values can be set where NINJA_DEPEND will then be set
# to a blank variable.
# The default is set to "ninja".
: "${NINJA:=ninja}"

# @ECLASS_VARIABLE: NINJA_DEPEND
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Contains a set of build-time dependencies based on the NINJA setting.

# @ECLASS_VARIABLE: NINJAOPTS
# @DEFAULT_UNSET
# @DESCRIPTION:
# The default set of options to pass to Ninja. Similar to MAKEOPTS,
# supposed to be set in make.conf. If unset, eninja() will convert
# MAKEOPTS instead.

# @ECLASS_VARIABLE: NINJA_VERBOSE
# @USER_VARIABLE
# @DESCRIPTION:
# Set to OFF to disable verbose messages during compilation
: "${NINJA_VERBOSE:=ON}"

inherit multiprocessing

NINJA_DEPEND="app-alternatives/ninja"

# @FUNCTION: get_NINJAOPTS
# @DESCRIPTION:
# Get the value of NINJAOPTS, inferring them from MAKEOPTS if unset.
get_NINJAOPTS() {
	if [[ -z ${NINJAOPTS+set} ]]; then
		NINJAOPTS="-j$(get_makeopts_jobs 999) -l$(get_makeopts_loadavg 0)"
	fi
	echo "${NINJAOPTS}"
}

# @FUNCTION: eninja
# @USAGE: [<args>...]
# @DESCRIPTION:
# Call Ninja, passing the NINJAOPTS (or converted MAKEOPTS), followed
# by the supplied arguments.  This function dies if ninja fails.  It
# also supports being called via 'nonfatal'.
eninja() {
	case "${NINJA}" in
		ninja|samu)
			;;
		*)
			ewarn "Unknown value '${NINJA}' for \${NINJA}"
			;;
	esac

	local v
	case "${NINJA_VERBOSE}" in
		OFF) ;;
		*) v="-v"
	esac
	set -- "${NINJA}" ${v} $(get_NINJAOPTS) "$@"
	echo "$@" >&2
	"$@" || die -n "${*} failed"
}

fi
