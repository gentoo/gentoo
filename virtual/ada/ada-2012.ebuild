# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Virtual for selecting an appropriate Ada compiler"
HOMEPAGE=""
SRC_URI=""
LICENSE=""
SLOT="2012"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

# Only one at present, but gnat-gcc-5.x is coming soon (I Swear)
RDEPEND="|| (
	>=virtual/gnat-4.9 )"
DEPEND=""
