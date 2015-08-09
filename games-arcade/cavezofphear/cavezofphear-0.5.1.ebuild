# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A boulder dash / digger-like game for console using ncurses"
HOMEPAGE="http://www.x86.no/cavezofphear/"
SRC_URI="http://www.x86.no/${PN}/${P/cavezof}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P/cavezof/}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i \
		-e "s:get_data_dir(.):\"${GAMES_DATADIR}/${PN}/\":" \
		src/{chk.c,main.c,gplot.c} \
		|| die
}

src_install() {
	dogamesbin src/phear
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/*
	dodoc ChangeLog README* TODO
	prepgamesdirs
}
