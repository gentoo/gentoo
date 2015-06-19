# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/pcgen/pcgen-6.04.01.ebuild,v 1.3 2015/03/25 13:49:46 ago Exp $

EAPI=5
inherit gnome2-utils games

DESCRIPTION="D&D character generator"
HOMEPAGE="http://pcgen.sourceforge.net/"
SRC_URI="mirror://sourceforge/pcgen/${P}-full.zip"

LICENSE="LGPL-2.1 OGL-1.0a"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND="app-arch/unzip"

S=${WORKDIR}/${PN}

src_prepare() {
	rm -vf *.bat
	sed "/dirname/ c\cd \"${GAMES_DATADIR}\/${PN}\"" pcgen.sh > "${T}"/${PN} || die
}

src_install() {
	dogamesbin "${T}"/${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r *
	newicon -s 128 system/sponsors/pcgen/pcgen_128x128.png ${PN}.png
	make_desktop_entry ${PN} PCGen
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
