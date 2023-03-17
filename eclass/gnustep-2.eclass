# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gnustep-2.eclass
# @MAINTAINER:
# GNUstep Herd <gnustep@gentoo.org>
# @SUPPORTED_EAPIS: 6 7 8
# @PROVIDES: gnustep-base
# @BLURB: eclass for GNUstep Apps, Frameworks, and Bundles build
# @DESCRIPTION:
# This eclass sets up GNUstep environment to properly install
# GNUstep packages

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GNUSTEP_2_ECLASS} ]] ; then
_GNUSTEP_2_ECLASS=1

inherit gnustep-base

case ${EAPI} in
	6)
		DEPEND=">=gnustep-base/gnustep-make-2.0"
		;;
	*)
		BDEPEND=">=gnustep-base/gnustep-make-2.0"
		;;
esac

DEPEND+=" virtual/gnustep-back"
RDEPEND="${DEPEND}"

# The following gnustep-based exported functions are available:
# * gnustep-base_pkg_setup
# * gnustep-base_src_prepare
# * gnustep-base_src_configure
# * gnustep-base_src_compile
# * gnustep-base_src_install
# * gnustep-base_pkg_postinst

fi
