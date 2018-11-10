# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils

DESCRIPTION="Tool for working with JTAG-aware devices and boards through JTAG adapter"
HOMEPAGE="http://openwince.sourceforge.net/jtag/"
SRC_URI="mirror://sourceforge/openwince/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ~ppc"
IUSE=""

DEPEND="dev-embedded/include"
RDEPEND="${DEPEND}
	!dev-embedded/urjtag"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-erase-overshoot.diff
}
