# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/trophy/trophy-2.0.3.ebuild,v 1.3 2013/12/24 12:58:00 ago Exp $

EAPI=5
inherit eutils gnome2-utils games

DESCRIPTION="2D Racing Game"
HOMEPAGE="http://trophy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-games/clanlib:0.8[opengl]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	default
	doicon -s 72 "${D}${GAMES_DATADIR}"/icons/${PN}.png
	rm -rf "${D}${GAMES_DATADIR}"/icons
	domenu "${D}${GAMES_DATADIR}"/applications/${PN}.desktop
	rm -rf "${D}${GAMES_DATADIR}"/applications
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
