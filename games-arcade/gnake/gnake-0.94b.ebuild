# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

DESCRIPTION="An ncurses-based Nibbles clone"
HOMEPAGE="http://lightless.org/gnake"
SRC_URI="mirror://gentoo/Gnake.${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND="sys-libs/ncurses:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

src_compile() {
	emake LDLIBS="$(pkg-config ncurses --libs)" gnake
}

src_install() {
	dogamesbin gnake
	dodoc README
	prepgamesdirs
}
