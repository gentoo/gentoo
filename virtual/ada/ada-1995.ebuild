# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/ada/ada-1995.ebuild,v 1.5 2010/01/11 10:54:52 ulm Exp $

DESCRIPTION="Virtual for selecting an appropriate Ada compiler"
HOMEPAGE=""
SRC_URI=""
LICENSE=""

# Different versions of Ada compilers can and likely will be installed side by
# side
SLOT="1995"

KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="|| (
	=dev-lang/gnat-gcc-4.2*
	=dev-lang/gnat-gcc-4.1*
	=dev-lang/gnat-gcc-3.4*
	=dev-lang/gnat-gpl-3.4* )"
DEPEND=""
