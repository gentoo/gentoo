# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: eutils.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 6 7
# @BLURB: many extra (but common) functions that are used in ebuilds
# @DEPRECATED: native package manager functions, more specific eclasses

if [[ -z ${_EUTILS_ECLASS} ]]; then
_EUTILS_ECLASS=1

# implicitly inherited (now split) eclasses
case ${EAPI} in
	6) inherit desktop edos2unix epatch eqawarn estack ltprune multilib \
			preserve-libs strip-linguas toolchain-funcs vcs-clean wrapper ;;
	7) inherit edos2unix strip-linguas wrapper ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

emktemp() {
	eerror "emktemp has been removed."
	eerror "Create a temporary file in \${T} instead."
	die "emktemp is banned"
}

# @FUNCTION: path_exists
# @INTERNAL
# @DESCRIPTION:
#
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

fi
