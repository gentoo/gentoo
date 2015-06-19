# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gnustep-2.eclass,v 1.7 2012/05/29 08:05:05 phajdan.jr Exp $

# @ECLASS: gnustep-2.eclass
# @MAINTAINER:
# GNUstep Herd <gnustep@gentoo.org>
# @BLURB: eclass for GNUstep Apps, Frameworks, and Bundles build
# @DESCRIPTION:
# This eclass sets up GNUstep environment to properly install
# GNUstep packages

inherit gnustep-base

DEPEND=">=gnustep-base/gnustep-make-2.0
	virtual/gnustep-back"
RDEPEND="${DEPEND}
	debug? ( !<sys-devel/gdb-6.0 )"

# The following gnustep-based EXPORT_FUNCTIONS are available:
# * gnustep-base_pkg_setup
# * gnustep-base_src_unpack (EAPI 0|1 only)
# * gnustep-base_src_prepare (EAPI>=2 only)
# * gnustep-base_src_configure (EAPI>=2 only)
# * gnustep-base_src_compile
# * gnustep-base_src_install
# * gnustep-base_pkg_postinst
