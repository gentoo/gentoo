# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="a simple, evil, ncurses-based Tetris(R) clone"
HOMEPAGE="http://fph.altervista.org/prog/bastet.shtml"
SRC_URI="http://fph.altervista.org/prog/files/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

DEPEND="sys-libs/ncurses:0
	dev-libs/boost:0"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	dogamesbin bastet
	doman bastet.6
	dodoc AUTHORS NEWS README
	dodir "${GAMES_STATEDIR}"
	touch "${D}${GAMES_STATEDIR}/bastet.scores" || die "touch failed"
	fperms 664 "${GAMES_STATEDIR}/bastet.scores"
	prepgamesdirs
}
