# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

MY_PN="GNUDoku"
MY_P=${MY_PN}-${PV}
DESCRIPTION="A program for creating and solving Su Doku puzzles"
HOMEPAGE="http://www.icculus.org/~jcspray/GNUDoku"
SRC_URI="http://www.icculus.org/~jcspray/GNUDoku/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
RESTRICT="test"

RDEPEND=">=dev-cpp/gtkmm-2.6:2.4"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch
	sed -i \
		-e "s:\$(CXX):\$(CXX) ${CXXFLAGS} ${LDFLAGS}:" \
		Makefile \
		|| die "sed failed"
}

src_install() {
	dogamesbin GNUDoku
	newicon GNUDoku.png ${PN}.png
	make_desktop_entry ${MY_PN} ${MY_PN}
	dodoc ALGORITHM Changelog README TODO
	prepgamesdirs
}
