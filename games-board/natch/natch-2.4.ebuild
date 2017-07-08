# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils games

MY_P="Natch-${PV}"
DESCRIPTION="A program to solve chess proof games"
HOMEPAGE="http://natch.free.fr/Natch.html"
SRC_URI="http://natch.free.fr/Natch/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-libs/ncurses:0"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-format.patch
}

src_install() {
	newgamesbin src/Natch natch
	dodoc AUTHORS ChangeLog NEWS README THANKS example.txt
	prepgamesdirs
}
