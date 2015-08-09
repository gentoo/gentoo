# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gnome2-utils games

DESCRIPTION="A mashup of \"Not\" and \"Pacman\""
HOMEPAGE="http://stabyourself.net/notpacman/"
SRC_URI="http://stabyourself.net/dl.php?file=notpacman-1004/notpacman-linux.zip -> ${P}.zip
	http://dev.gentoo.org/~hasufell/distfiles/${PN}.png"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

LVSLOT="0.7"
RDEPEND=">=games-engines/love-0.7.2:${LVSLOT}
	 media-libs/devil[png]"
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_install() {
	local dir=${GAMES_DATADIR}/love/${PN}

	exeinto "${dir}"
	newexe not_pacman.love ${PN}.love

	dodoc README

	doicon -s 32 "${DISTDIR}"/${PN}.png
	games_make_wrapper ${PN} "love-${LVSLOT} ${PN}.love" "${dir}"
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
