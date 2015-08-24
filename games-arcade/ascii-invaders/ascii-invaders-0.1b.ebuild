# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

DESCRIPTION="Space invaders clone, using ncurses library"
HOMEPAGE="https://packages.gentoo.org/package/games-arcade/ascii-invaders"
SRC_URI="mirror://gentoo/invaders${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~ppc-macos"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/invaders

src_prepare() {
	rm -f Makefile
}

src_compile() {
	emake LDLIBS="$(pkg-config ncurses --libs)" invaders
}

src_install() {
	newgamesbin invaders ${PN}
	dodoc TODO
	prepgamesdirs
}
