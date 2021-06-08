# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="Bomberman-like multiplayer game"
HOMEPAGE="https://savannah.nongnu.org/projects/clanbomber/"
SRC_URI="https://download.savannah.gnu.org/releases/${PN}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	dev-libs/boost:=
	media-fonts/dejavu
	media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/sdl-mixer
	media-libs/sdl-ttf"
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
	make_desktop_entry ${PN}2 ClanBomber2

	rm "${ED}/usr/share/${PN}/fonts/DejaVuSans-Bold.ttf" || die
	dosym ../../fonts/dejavu/DejaVuSans-Bold.ttf \
		/usr/share/${PN}/fonts/DejaVuSans-Bold.ttf
}
