# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: eutils.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 6
# @BLURB: many extra (but common) functions that are used in ebuilds
# @DEPRECATED: native package manager functions, more specific eclasses

if [[ -z ${_EUTILS_ECLASS} ]]; then
_EUTILS_ECLASS=1

# implicitly inherited (now split) eclasses
case ${EAPI} in
	6) inherit desktop edos2unix epatch eqawarn estack ltprune multilib \
			preserve-libs strip-linguas toolchain-funcs vcs-clean wrapper ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac
fi
