# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils games

DESCRIPTION="A violent point-and-click shooting game"
HOMEPAGE="http://lgames.sourceforge.net"
SRC_URI="mirror://sourceforge/lgames/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2[sound,video]
	>=media-libs/sdl-mixer-1.2.4"
RDEPEND="${DEPEND}"

src_configure() {
	egamesconf --datadir="${GAMES_DATADIR_BASE}"
}

src_install() {
	default
	newicon barrage48.png ${PN}.png
	make_desktop_entry ${PN} Barrage
	rm "${D}"/usr/share/applications/${PN}.desktop
	prepgamesdirs
}
