# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ninja-utils.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# Mike Gilbert <floppym@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# Mike Gilbert <floppym@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7 8
# @BLURB: common bits to run dev-util/ninja builder
# @DESCRIPTION:
# This eclass provides a single function -- eninja -- that can be used
# to run the ninja builder alike emake. It does not define any
# dependencies, you need to depend on dev-util/ninja yourself. Since
# ninja is rarely used stand-alone, most of the time this eclass will
# be used indirectly by the eclasses for other build systems (CMake,
# Meson).

case ${EAPI} in
	5|6|7|8) ;;
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
: ${NINJA:=ninja}

# @ECLASS_VARIABLE: NINJA_DEPEND
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Contains a set of build-time depenendencies based on the NINJA setting.

# @ECLASS_VARIABLE: NINJAOPTS
# @DEFAULT_UNSET
# @DESCRIPTION:
# The default set of options to pass to Ninja. Similar to MAKEOPTS,
# supposed to be set in make.conf. If unset, eninja() will convert
# MAKEOPTS instead.

inherit multiprocessing

case "${NINJA}" in
	ninja)
		NINJA_DEPEND=">=dev-util/ninja-1.8.2"
	;;
	samu)
		NINJA_DEPEND="dev-util/samurai"
	;;
	*)
		NINJA_DEPEND=""
	;;
esac

# @FUNCTION: eninja
# @USAGE: [<args>...]
# @DESCRIPTION:
# Call Ninja, passing the NINJAOPTS (or converted MAKEOPTS), followed
# by the supplied arguments. This function dies if ninja fails. Starting
# with EAPI 6, it also supports being called via 'nonfatal'.
eninja() {
	local nonfatal_args=()
	[[ ${EAPI} != 5 ]] && nonfatal_args+=( -n )

	if [[ -z ${NINJAOPTS+set} ]]; then
		NINJAOPTS="-j$(makeopts_jobs "${MAKEOPTS}" 999) -l$(makeopts_loadavg "${MAKEOPTS}" 0)"
	fi
	[[ -n "${NINJA_DEPEND}" ]] || ewarn "Unknown value '${NINJA}' for \${NINJA}"
	set -- "${NINJA}" -v ${NINJAOPTS} "$@"
	echo "$@" >&2
	"$@" || die "${nonfatal_args[@]}" "${*} failed"
}

fi
