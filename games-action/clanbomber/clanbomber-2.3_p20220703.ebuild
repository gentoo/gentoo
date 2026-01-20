# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=b0f00ecc784d1cbef8c6672712fbeb0f03d324b3
inherit autotools desktop

DESCRIPTION="Bomberman-like multiplayer game"
HOMEPAGE="https://github.com/viti95/ClanBomber2
https://savannah.nongnu.org/projects/clanbomber/"
SRC_URI="https://github.com/viti95/ClanBomber2/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
S="${WORKDIR}/ClanBomber2-${COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	media-fonts/dejavu
	media-libs/libsdl2[sound,joystick,video]
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog ChangeLog.hg IDEAS NEWS QUOTES README TODO )

src_prepare() {
	default
	sed -i -e 's/menuentry//' src/Makefile.am || die
	eautoreconf
}

src_install() {
	default

	newicon src/pics/cup2.png ${PN}.png
	make_desktop_entry --eapi9 ${PN}2 -n ClanBomber2 -C "Bomb your way through the maze"

	rm "${ED}/usr/share/${PN}/fonts/DejaVuSans-Bold.ttf" || die
	dosym ../../fonts/dejavu/DejaVuSans-Bold.ttf \
		/usr/share/${PN}/fonts/DejaVuSans-Bold.ttf
}
