# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/seatris/seatris-0.0.14.ebuild,v 1.13 2014/10/31 02:00:21 mr_bones_ Exp $

EAPI=5
inherit eutils toolchain-funcs games

DESCRIPTION="A color ncurses tetris clone"
HOMEPAGE="http://www.earth.li/projectpurple/progs/seatris.html"
SRC_URI="http://www.earth.li/projectpurple/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"

RDEPEND="sys-libs/ncurses"
DEPEND="${DEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e "s:/var/lib/games:${GAMES_STATEDIR}:" \
		scoring.h seatris.6 || die

	epatch "${FILESDIR}"/${P}-as-needed.patch
}

src_compile() {
	emake LIBS="$( $(tc-getPKG_CONFIG) --libs ncurses )"
}

src_install () {
	dogamesbin seatris
	doman seatris.6
	dodoc ACKNOWLEDGEMENTS HISTORY README TODO example.seatrisrc
	dodir "${GAMES_STATEDIR}"
	touch "${D}${GAMES_STATEDIR}/seatris.score"
	fperms 660 "${GAMES_STATEDIR}/seatris.score"
	prepgamesdirs
}
