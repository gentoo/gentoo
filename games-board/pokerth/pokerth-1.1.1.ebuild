# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic eutils qt4-r2 games

MY_P="PokerTH-${PV}-src"
DESCRIPTION="Texas Hold'em poker game"
HOMEPAGE="http://www.pokerth.net/"
SRC_URI="mirror://sourceforge/pokerth/${MY_P}.tar.bz2"

LICENSE="AGPL-3 GPL-1 GPL-2 GPL-3 BitstreamVera public-domain"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="dedicated"

RDEPEND="dev-db/sqlite:3
	dev-libs/boost:=[threads(+)]
	dev-libs/protobuf
	dev-libs/libgcrypt:0
	dev-libs/tinyxml[stl]
	amd64? ( net-libs/libircclient )
	ppc? ( >=net-libs/libircclient-1.6-r2 )
	x86? ( net-libs/libircclient )
	>=net-misc/curl-7.16
	dev-qt/qtcore:4
	virtual/gsasl
	!dedicated? (
		media-libs/libsdl:0
		media-libs/sdl-mixer[mod,vorbis]
		dev-qt/qtgui:4
	)"
DEPEND="${RDEPEND}
	!dedicated? ( dev-qt/qtsql:4 )
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	if use dedicated ; then
		sed -i \
			-e 's/pokerth_game.pro//' \
			pokerth.pro || die
	fi

	sed -i \
		-e '/no_dead_strip_inits_and_terms/d' \
		*pro || die

	#epatch "${FILESDIR}"/${P}-underlinking.patch
}

src_configure() {
	eqmake4
}

src_install() {
	dogamesbin bin/pokerth_server
	if ! use dedicated ; then
		dogamesbin ${PN}
		insinto "${GAMES_DATADIR}/${PN}"
		doins -r data
		domenu ${PN}.desktop
		doicon ${PN}.png
	fi
	doman docs/pokerth.1
	dodoc ChangeLog TODO docs/{gui_styling,server_setup}_howto.txt
	prepgamesdirs
}
