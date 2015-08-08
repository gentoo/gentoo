# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gnome2-utils games

DESCRIPTION="Arcade styled 2d action game centered around evacuating civilians from burning buildings"
HOMEPAGE="http://tangramgames.dk/games/mrrescue/"
SRC_URI="https://github.com/SimonLarsen/mrrescue/releases/download/v${PV}/${P}-love.zip
	http://dev.gentoo.org/~hasufell/distfiles/${PN}.png"

LICENSE="CC-BY-SA-3.0 MIT ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="games-engines/love:0"
DEPEND="app-arch/unzip"

S=${WORKDIR}/${P}-love

src_install() {
	local dir=${GAMES_DATADIR}/love/${PN}

	exeinto "${dir}"
	doexe ${PN}.love

	dodoc README.txt

	doicon -s 64 "${DISTDIR}"/${PN}.png
	games_make_wrapper ${PN} "love ${PN}.love" "${dir}"
	make_desktop_entry ${PN}

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
