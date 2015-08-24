# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gnome2-utils games

DESCRIPTION="A game made in 20 hours for a friend. It has explosions"
HOMEPAGE="http://stabyourself.net/trosh/"
SRC_URI="http://stabyourself.net/dl.php?file=trosh/trosh-linux.zip -> ${P}.zip
	https://dev.gentoo.org/~hasufell/distfiles/${PN}.png"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=games-engines/love-0.8.0
	 media-libs/devil[png]"
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_install() {
	local dir=${GAMES_DATADIR}/love/${PN}

	exeinto "${dir}"
	doexe ${PN}.love

	dodoc {LICENSE,readme}.txt README

	doicon -s 32 "${DISTDIR}"/${PN}.png
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
