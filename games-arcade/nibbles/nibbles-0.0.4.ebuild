# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

MY_P=${PN}-v${PV}
DESCRIPTION="An ncurses-based Nibbles clone"
HOMEPAGE="http://www.earth.li/projectpurple/progs/nibbles.html"
SRC_URI="http://www.earth.li/projectpurple/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="sys-libs/ncurses:0"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i \
		-e "s#/usr/local/games/nibbles.levels#${GAMES_DATADIR}/${PN}#" \
		nibbles.h || die

	sed -i \
		-e "s#/var/lib/games/nibbles.score#${GAMES_STATEDIR}/nibbles.scores#" \
		scoring.h || die

	epatch "${FILESDIR}"/${P}-as-needed.patch
}

src_install() {
	dogamesbin nibbles

	insinto "${GAMES_DATADIR}/${PN}"
	doins nibbles.levels/*

	dodir "${GAMES_STATEDIR}"
	touch "${D}${GAMES_STATEDIR}/nibbles.scores"

	dodoc HISTORY CREDITS TODO README

	prepgamesdirs

	fperms 664 "${GAMES_STATEDIR}/nibbles.scores"
}
