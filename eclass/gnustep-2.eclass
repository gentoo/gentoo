# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gnustep-2.eclass
# @MAINTAINER:
# GNUstep Herd <gnustep@gentoo.org>
# @SUPPORTED_EAPIS: 0 1 2 3 4 5 6 7
# @BLURB: eclass for GNUstep Apps, Frameworks, and Bundles build
# @DESCRIPTION:
# This eclass sets up GNUstep environment to properly install
# GNUstep packages

inherit gnustep-base

DEPEND=">=gnustep-base/gnustep-make-2.0
	virtual/gnustep-back"
RDEPEND="${DEPEND}"

# The following gnustep-based EXPORT_FUNCTIONS are available:
# * gnustep-base_pkg_setup
# * gnustep-base_src_unpack (EAPI 0|1 only)
# * gnustep-base_src_prepare (EAPI>=2 only)
# * gnustep-base_src_configure (EAPI>=2 only)
# * gnustep-base_src_compile
# * gnustep-base_src_install
# * gnustep-base_pkg_postinst
