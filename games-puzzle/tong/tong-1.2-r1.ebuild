# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Tetris and Pong in the same place at the same time"
HOMEPAGE="http://www.nongnu.org/tong/"
SRC_URI="http://www.nongnu.org/tong/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	eapply \
		"${FILESDIR}/${P}-makefile.patch" \
		"${FILESDIR}/${P}-fps.patch" \
		"${FILESDIR}/${P}-datadir.patch"
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
