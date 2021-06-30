# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gnustep-2.eclass
# @MAINTAINER:
# GNUstep Herd <gnustep@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
# @BLURB: eclass for GNUstep Apps, Frameworks, and Bundles build
# @DESCRIPTION:
# This eclass sets up GNUstep environment to properly install
# GNUstep packages

case ${EAPI:-0} in
	[567]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GNUSTEP_2_ECLASS} ]] ; then
_GNUSTEP_2_ECLASS=1

inherit gnustep-base

case ${EAPI:-0} in
	[56])
		DEPEND=">=gnustep-base/gnustep-make-2.0"
		;;
	*)
		BDEPEND=">=gnustep-base/gnustep-make-2.0"
		;;
esac

DEPEND+=" virtual/gnustep-back"
RDEPEND="${DEPEND}"

# The following gnustep-based EXPORT_FUNCTIONS are available:
# * gnustep-base_pkg_setup
# * gnustep-base_src_unpack (EAPI 0|1 only)
# * gnustep-base_src_prepare (EAPI>=2 only)
# * gnustep-base_src_configure (EAPI>=2 only)
# * gnustep-base_src_compile
# * gnustep-base_src_install
# * gnustep-base_pkg_postinst

fi
