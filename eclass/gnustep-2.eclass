# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gnustep-2.eclass
# @MAINTAINER:
# GNUstep Herd <gnustep@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: gnustep-base
# @BLURB: eclass for GNUstep Apps, Frameworks, and Bundles build
# @DESCRIPTION:
# This eclass sets up GNUstep environment to properly install
# GNUstep packages

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GNUSTEP_2_ECLASS} ]] ; then
_GNUSTEP_2_ECLASS=1

inherit gnustep-base

RDEPEND="virtual/gnustep-back"
DEPEND="${RDEPEND}"
BDEPEND=">=gnustep-base/gnustep-make-2.0"

# The following gnustep-based exported functions are available:
# * gnustep-base_pkg_setup
# * gnustep-base_src_prepare
# * gnustep-base_src_configure
# * gnustep-base_src_compile
# * gnustep-base_src_install
# * gnustep-base_pkg_postinst

fi
