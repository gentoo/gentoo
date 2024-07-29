# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Tetris and Pong in the same place at the same time"
HOMEPAGE="https://www.nongnu.org/tong/"
SRC_URI="https://www.nongnu.org/tong/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-makefile.patch"
	"${FILESDIR}/${P}-fps.patch"
	"${FILESDIR}/${P}-datadir.patch"
)

src_prepare() {
	default

	sed -i \
		-e "s:\"media/:\"/usr/share/${PN}/media/:" \
		media.cpp option.cpp option.h pong.cpp tetris.cpp text.cpp \
		|| die
	cp media/icon.png "${T}/${PN}.png" || die
}

src_install() {
	dobin tong
	dodir "/usr/share/${PN}"
	cp -r media/ "${ED}/usr/share/${PN}" || die
	dodoc CHANGELOG README making-of.txt CREDITS

	make_desktop_entry tong TONG
	doicon "${T}/${PN}.png"
}
