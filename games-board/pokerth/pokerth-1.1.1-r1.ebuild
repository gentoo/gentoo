# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic eutils qmake-utils games

MY_P="PokerTH-${PV}-src"
DESCRIPTION="Texas Hold'em poker game"
HOMEPAGE="http://www.pokerth.net/"
SRC_URI="mirror://sourceforge/pokerth/${MY_P}.tar.bz2"

LICENSE="AGPL-3 GPL-1 GPL-2 GPL-3 BitstreamVera public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated"

RDEPEND="dev-db/sqlite:3
	dev-libs/boost:=[threads(+)]
	dev-libs/protobuf
	dev-libs/libgcrypt:0
	dev-libs/tinyxml[stl]
	>=net-libs/libircclient-1.6-r2
	>=net-misc/curl-7.16
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	virtual/gsasl
	!dedicated? (
		media-libs/libsdl:0
		media-libs/sdl-mixer[mod,vorbis]
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}
	!dedicated? ( dev-qt/qtsql:5 )
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	if use dedicated ; then
		sed -i -e 's/pokerth_game.pro//' pokerth.pro || die
	fi

	sed -i -e '/no_dead_strip_inits_and_terms/d' *pro || die

	epatch "${FILESDIR}"/${P}-qt5.patch
}

src_configure() {
	eqmake5 pokerth.pro
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
