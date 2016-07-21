# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A UNIX-hosted, curses-based clone of the nifty little Macintosh freeware game Galaxis"
HOMEPAGE="http://www.catb.org/~esr/galaxis/"
SRC_URI="http://www.catb.org/~esr/galaxis/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.3:0"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	dogamesbin galaxis
	doman galaxis.6
	dodoc README
	prepgamesdirs
}
