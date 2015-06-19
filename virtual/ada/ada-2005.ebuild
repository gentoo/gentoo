# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/ada/ada-2005.ebuild,v 1.7 2014/08/10 20:11:16 slyfox Exp $

DESCRIPTION="Virtual for selecting an appropriate Ada compiler"
HOMEPAGE=""
SRC_URI=""
LICENSE=""
SLOT="2005"
KEYWORDS="amd64 ppc x86"
IUSE=""

# Only one at present, but gnat-gcc-4.3 is coming soon too
RDEPEND="|| (
	>=dev-lang/gnat-gcc-4.3
	>=dev-lang/gnat-gpl-4.1 )"
DEPEND=""
