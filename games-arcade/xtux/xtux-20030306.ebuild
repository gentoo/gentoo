# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Multiplayer Gauntlet-style arcade game"
HOMEPAGE="http://xtux.sourceforge.net/"
SRC_URI="mirror://sourceforge/xtux/xtux-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="x11-libs/libXpm"
RDPENED="${DEPEND}"
S=${WORKDIR}/${PN}

src_prepare() {
	find data/ -type d -name .xvpics -exec rm -rf \{\} +
	sed -i \
		-e "s:-g -Wall -O2:${CFLAGS}:" \
		src/{client,common,server}/Makefile \
		|| die "sed failed"
	sed -i \
		-e "s:./tux_serv:tux_serv:" \
		src/client/menu.c \
		|| die "sed failed"
	epatch "${FILESDIR}/${P}-particles.patch" \
		"${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	# Not parallel-make friendly (bug #247332)
	emake DATADIR="${GAMES_DATADIR}/xtux/data" common
	emake DATADIR="${GAMES_DATADIR}/xtux/data" ggz
	emake DATADIR="${GAMES_DATADIR}/xtux/data" server
	emake DATADIR="${GAMES_DATADIR}/xtux/data" client
}

src_install () {
	dogamesbin xtux tux_serv
	insinto "${GAMES_DATADIR}/xtux"
	doins -r data/
	dodoc AUTHORS CHANGELOG README README.GGZ doc/*
	newicon data/images/icon.xpm ${PN}.xpm
	make_desktop_entry xtux "Xtux"
	prepgamesdirs
}
