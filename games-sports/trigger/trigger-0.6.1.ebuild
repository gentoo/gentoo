# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/trigger/trigger-0.6.1.ebuild,v 1.3 2015/04/19 10:08:23 ago Exp $

EAPI=5
inherit eutils games

MY_PN=${PN}-rally
MY_P=${MY_PN}-${PV}
DESCRIPTION="Free OpenGL rally car racing game"
HOMEPAGE="http://www.positro.net/trigger/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer
	media-libs/openal
	media-libs/freealut
	dev-games/physfs"
DEPEND="${RDEPEND}
	dev-util/ftjam"

S=${WORKDIR}/${MY_P}

src_configure() {
	egamesconf --datadir="${GAMES_DATADIR}"/${PN}
}

src_compile() {
	AR="${AR} cru" jam -dx -qa || die
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/*
	newicon data/textures/life_helmet.png ${PN}.png
	make_desktop_entry ${PN} Trigger
	dodoc doc/*.txt
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "After running ${PN} for the first time, a config file is"
	elog "available in ~/.trigger/trigger.config"
}
