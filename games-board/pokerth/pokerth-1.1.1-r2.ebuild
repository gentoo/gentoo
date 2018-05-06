# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic qmake-utils

MY_P="PokerTH-${PV}-src"
DESCRIPTION="Texas Hold'em poker game"
HOMEPAGE="https://www.pokerth.net/"
SRC_URI="mirror://sourceforge/pokerth/${MY_P}.tar.bz2"

LICENSE="AGPL-3 GPL-1 GPL-2 GPL-3 BitstreamVera public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated"

RDEPEND="dev-db/sqlite:3
	dev-libs/boost:=[threads(+)]
	dev-libs/libgcrypt:0
	dev-libs/protobuf
	dev-libs/tinyxml[stl]
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	>=net-libs/libircclient-1.6-r2
	>=net-misc/curl-7.16
	virtual/gsasl
	!dedicated? (
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		media-libs/libsdl:0
		media-libs/sdl-mixer[mod,vorbis]
	)"
DEPEND="${RDEPEND}
	!dedicated? ( dev-qt/qtsql:5 )
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.1-qt5.patch
	"${FILESDIR}"/${PN}-1.1.1-boost-1.60.patch
	"${FILESDIR}"/${PN}-1.1.1-qmake-gcc-6.patch
	"${FILESDIR}"/${PN}-1.1.1-boost-noexcept.patch
	"${FILESDIR}"/${PN}-1.1.1-boost-1.65-ambiguous-advance.patch
)

src_prepare() {
	default

	if use dedicated; then
		sed -i -e 's/pokerth_game.pro//' pokerth.pro || die
	fi

	sed -i -e '/no_dead_strip_inits_and_terms/d' *pro || die
}

src_configure() {
	eqmake5 pokerth.pro
}

src_install() {
	dobin bin/pokerth_server
	if ! use dedicated; then
		dobin ${PN}
		insinto /usr/share/${PN}
		doins -r data
		domenu ${PN}.desktop
		doicon ${PN}.png
	fi

	einstalldocs
	dodoc docs/{gui_styling,server_setup}_howto.txt

	doman docs/pokerth.1
}
