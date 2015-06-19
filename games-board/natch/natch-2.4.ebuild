# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/natch/natch-2.4.ebuild,v 1.5 2014/10/17 06:48:11 tupone Exp $

EAPI=5
inherit eutils games

MY_P="Natch-${PV}"
DESCRIPTION="A program to solve chess proof games"
HOMEPAGE="http://natch.free.fr/Natch.html"
SRC_URI="http://natch.free.fr/Natch/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="sys-libs/ncurses"
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
