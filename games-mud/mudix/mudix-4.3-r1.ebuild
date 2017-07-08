# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils games

DESCRIPTION="A small, stable MUD client for the console"
HOMEPAGE="http://dw.nl.eu.org/mudix.html"
SRC_URI="http://dw.nl.eu.org/mudix/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-libs/ncurses:0"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-as-needed.patch
}

src_compile() {
	emake -C src O_FLAGS="${CFLAGS}"
}

src_install () {
	dogamesbin mudix
	dodoc README sample.usr
	prepgamesdirs
}
