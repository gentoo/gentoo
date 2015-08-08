# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="Free software bass synthesizer step sequencer"
HOMEPAGE="http://freshmeat.net/releases/8834"
SRC_URI="http://www.bitmechanic.com/projects/freebirth/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo-2.patch \
		"${FILESDIR}"/${P}-segfault.patch
}

src_compile() {
	tc-export CC
	emake || die
}

src_install() {
	dobin ${PN} || die

	insinto /usr/share/${PN}/raw
	doins raw/*.raw || die

	dodoc CHANGES NEXT_VERSION README

	doicon xpm/${PN}.xpm
	make_desktop_entry ${PN} ${PN}
}
