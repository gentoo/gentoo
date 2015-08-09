# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnome2-utils games

MY_PN=${PN}-branding
MY_P=${MY_PN}-${PV}

DESCRIPTION="Branding for the Mana client for server.themanaworld.org"
HOMEPAGE="http://themanaworld.org/"
SRC_URI="mirror://sourceforge/themanaworld/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="games-rpg/manaplus"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${MY_P}-gentoo.patch

	sed -i \
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		${PN} ${PN}.desktop \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}

	insinto "${GAMES_DATADIR}/${PN}/"
	doins ${PN}.mana
	doins -r data/

	domenu ${PN}.desktop

	doicon -s 32 data/icons/${PN}.xpm
	doicon data/icons/${PN}.png

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
