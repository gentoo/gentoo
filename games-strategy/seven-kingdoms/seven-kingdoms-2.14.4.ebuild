# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils games

MY_PN="7kaa"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Seven Kingdoms: Ancient Adversaries"
HOMEPAGE="http://7kfans.com/"
SRC_URI="mirror://sourceforge/skfans/${MY_PN}-source-${PV}.tar.bz2
	https://dev.gentoo.org/~pinkbyte/distfiles/${MY_PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="network"

DEPEND="media-libs/libsdl[X,video]
	media-libs/openal
	network? ( media-libs/sdl-net )
	!games-strategy/seven-kingdoms-data"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( README )

src_prepare() {
	sed -i -e '/#include <player_desc.h>/a\#include <string.h>' src/multiplayer/common/player_desc.cpp || die 'sed failed'

	autotools-utils_src_prepare
}

src_configure() {
	# In current state debugging works only on Windows :-/
	egamesconf \
		$(use_enable network) \
		--disable-debug \
		--without-directx \
		--without-wine \
		--datadir="${GAMES_DATADIR}/${MY_PN}"
}

src_install() {
	autotools-utils_src_install

	newgamesbin "src/client/${MY_PN}" "${MY_PN}.bin"
	doicon "${DISTDIR}/${MY_PN}.png"
	games_make_wrapper "${MY_PN}" "${GAMES_BINDIR}/${MY_PN}.bin" "${GAMES_DATADIR}/${MY_PN}"
	make_desktop_entry "${MY_PN}" "Seven Kingdoms: Ancient Adversaries" "${MY_PN}" "Game;StrategyGame"

	prepgamesdirs
}
