# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils games

DESCRIPTION="Defend your volcano from the attacking ants by firing rocks/bullets at them"
HOMEPAGE="http://koti.mbnet.fi/makegho/c/betna/"
SRC_URI="http://koti.mbnet.fi/makegho/c/betna/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/libsdl[video]"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e '/blobprintf.*char msg/s/char msg/const char msg/' \
		-e "s:images/:${GAMES_DATADIR}/${PN}/:" \
		src/main.cpp || die

	sed -i \
		-e '/^LDFLAGS/d' \
		-e '/--libs/s/-o/$(LDFLAGS) -o/' \
		-e 's:-O2:$(CXXFLAGS):g' \
		-e 's/g++/$(CXX)/' \
		Makefile || die
}

src_compile() {
	emake clean
	emake
}

src_install() {
	dogamesbin betna
	insinto "${GAMES_DATADIR}"/${PN}
	doins images/*
	newicon images/target.bmp ${PN}.bmp
	make_desktop_entry ${PN} Betna /usr/share/pixmaps/${PN}.bmp
	dodoc README Q\&A
	prepgamesdirs
}
