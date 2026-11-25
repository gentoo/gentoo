# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="The original Freedroid, a clone of the C64 classic Paradroid"
HOMEPAGE="https://github.com/ReinhardPrix/FreedroidClassic"
SRC_URI="https://github.com/ReinhardPrix/FreedroidClassic/archive/refs/tags/${P}-sdl2-port.tar.gz"
S=${WORKDIR}/FreedroidClassic-${P}-sdl2-port

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl2[joystick,sound,video]
	media-libs/sdl2-image[jpeg,png]
	media-libs/sdl2-mixer[mod,vorbis]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	newicon graphics/paraicon_48x48.png ${PN}.png
	make_desktop_entry --eapi9 ${PN} -c "Game;"
}
