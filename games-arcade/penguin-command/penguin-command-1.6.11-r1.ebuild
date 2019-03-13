# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="A clone of the classic Missile Command game"
HOMEPAGE="http://www.linux-games.com/penguin-command/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-mixer[mod]
	media-libs/sdl-image[jpeg,png]"
RDEPEND="${DEPEND}"

src_install() {
	default
	newicon data/gfx/icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Penguin Command" ${PN}
}
