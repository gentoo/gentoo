# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/penguin-command/penguin-command-1.6.11.ebuild,v 1.6 2015/01/05 16:35:00 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A clone of the classic Missile Command game"
HOMEPAGE="http://www.linux-games.com/penguin-command/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-mixer[mod]
	media-libs/sdl-image[jpeg,png]"
RDEPEND="${DEPEND}"

src_install() {
	default
	newicon data/gfx/icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Penguin Command" ${PN}
	prepgamesdirs
}
