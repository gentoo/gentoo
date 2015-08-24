# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils games

MY_PN="7kaa"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Seven Kingdoms: Ancient Adversaries"
HOMEPAGE="http://7kfans.com/"
SRC_URI="mirror://sourceforge/skfans/${MY_PN}-${PV}.tar.xz
	https://dev.gentoo.org/~pinkbyte/distfiles/${MY_PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-libs/enet:1.3=
	media-libs/libsdl2[X,video]
	media-libs/openal
	!games-strategy/seven-kingdoms-data"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( README )

src_unpack() {
	unpack ${MY_PN}-${PV}.tar.xz
}

src_prepare() {
	epatch_user
}

src_configure() {
	# In current state debugging works only on Windows :-/
	egamesconf \
		--disable-debug \
		--without-wine \
		--datadir="${GAMES_DATADIR}/${MY_PN}"
}

src_install() {
	default

	newgamesbin "src/client/${MY_PN}" "${MY_PN}.bin"
	doicon "${DISTDIR}/${MY_PN}.png"
	games_make_wrapper "${MY_PN}" "${GAMES_BINDIR}/${MY_PN}.bin" "${GAMES_DATADIR}/${MY_PN}"
	make_desktop_entry "${MY_PN}" "Seven Kingdoms: Ancient Adversaries" "${MY_PN}" "Game;StrategyGame"

	prepgamesdirs
}
