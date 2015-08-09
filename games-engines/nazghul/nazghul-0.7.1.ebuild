# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A computer role-playing game (CRPG) engine with game called HaximA"
HOMEPAGE="http://myweb.cableone.net/gmcnutt/nazghul.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libpng:0
	>=media-libs/libsdl-1.2.3[X,sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[midi,vorbis,wav]"
RDEPEND="${DEPEND}"

src_prepare() {
	ecvs_clean
}

src_configure() {
	egamesconf \
		--includedir=/usr/include
}

src_install() {
	default
	dodoc doc/{GAME_RULES,GHULSCRIPT,MAP_HACKERS_GUIDE,USERS_GUIDE}

	dohtml -a html,gif -r doc/*

	docinto engine_extension_and_design
	dodoc doc/engine_extension_and_design/*

	docinto world_building
	dodoc doc/world_building/*

	doicon icons/haxima.png
	make_desktop_entry haxima.sh HaximA haxima

	prepgamesdirs
}
