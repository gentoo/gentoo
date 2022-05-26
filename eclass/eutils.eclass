# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: eutils.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 6 7
# @BLURB: many extra (but common) functions that are used in ebuilds
# @DESCRIPTION:
# The eutils eclass contains a suite of functions that complement
# the ones that ebuild.sh already contain.  The idea is that the functions
# are not required in all ebuilds but enough utilize them to have a common
# home rather than having multiple ebuilds implementing the same thing.
#
# Due to the nature of this eclass, some functions may have maintainers
# different from the overall eclass!
#
# This eclass is DEPRECATED and must not be inherited by any new ebuilds
# or eclasses.  Use the more specific split eclasses instead, or native
# package manager functions when available.

if [[ -z ${_EUTILS_ECLASS} ]]; then
_EUTILS_ECLASS=1

# implicitly inherited (now split) eclasses
case ${EAPI} in
	6) inherit desktop edos2unix epatch estack ltprune multilib \
			preserve-libs strip-linguas toolchain-funcs vcs-clean wrapper ;;
	7) inherit edos2unix strip-linguas wrapper ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

emktemp() {
	eerror "emktemp has been removed."
	eerror "Create a temporary file in \${T} instead."
	die "emktemp is banned"
}

path_exists() {
	eerror "path_exists has been removed.  Please see the following post"
	eerror "for a replacement snippet:"
	eerror "https://blogs.gentoo.org/mgorny/2018/08/09/inlining-path_exists/"
	die "path_exists is banned"
}

use_if_iuse() {
	eerror "use_if_iuse has been removed."
	eerror "Define it as a local function, or inline it:"
	eerror "    in_iuse foo && use foo"
	die "use_if_iuse is banned"
}

# @FUNCTION: eqawarn
# @USAGE: [message]
# @DESCRIPTION:
# Proxy to ewarn for package managers that don't provide eqawarn and use the PM
# implementation if available. Reuses PORTAGE_ELOG_CLASSES as set by the dev
# profile.
if [[ ${EAPI} == 6 ]] && ! declare -F eqawarn >/dev/null ; then
	eqawarn() {
		has qa ${PORTAGE_ELOG_CLASSES} && ewarn "$@"
		:
	}
fi

fi
