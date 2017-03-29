# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Virtual for selecting an appropriate Ada compiler"
SLOT="2012"
KEYWORDS="~amd64 ~arm ~x86"

# Only one at present, but gnat-gcc-5.x is coming soon (I Swear)
RDEPEND="|| (
	>=virtual/gnat-4.9 )"
