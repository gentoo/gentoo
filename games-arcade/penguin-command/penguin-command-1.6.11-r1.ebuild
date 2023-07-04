# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Clone of the classic Missile Command game"
HOMEPAGE="https://www.linux-games.com/penguin-command/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-mixer[mod]
	media-libs/sdl-image[jpeg,png]"
RDEPEND="${DEPEND}"

src_install() {
	default
	newicon data/gfx/icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Penguin Command" ${PN}
}
