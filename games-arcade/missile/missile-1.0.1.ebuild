# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/missile/missile-1.0.1.ebuild,v 1.19 2015/03/31 16:09:48 mr_bones_ Exp $

EAPI=5
inherit eutils gnome2-utils games

DESCRIPTION="The game Missile Command for Linux"
HOMEPAGE="http://missile.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
	sed -i \
		-e '/^CC/d' \
		-e "s:\$(game_prefix)/\$(game_data):${GAMES_DATADIR}/${PN}:" \
		-e "s/-O2/${CFLAGS}/" \
		-e 's/-lSDL_image $(SND_LIBS)/-lSDL_image -lm $(SND_LIBS)/g' \
		Makefile || die
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/*
	newicon -s 48 icons/${PN}_icon_black.png ${PN}.png
	make_desktop_entry ${PN} "Missile Command"
	dodoc README
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
