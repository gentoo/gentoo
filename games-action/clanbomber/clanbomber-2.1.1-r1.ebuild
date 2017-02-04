# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils

DESCRIPTION="Bomberman-like multiplayer game"
HOMEPAGE="https://savannah.nongnu.org/projects/clanbomber/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-libs/boost
	media-fonts/dejavu
	media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/sdl-mixer
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog ChangeLog.hg IDEAS NEWS QUOTES README TODO )

PATCHES=(
		"${FILESDIR}"/${P}-automake112.patch
		"${FILESDIR}"/${P}-boost150.patch
)

src_prepare() {
	default
	sed -i -e 's/menuentry//' src/Makefile.am || die
	eautoreconf
}

src_install() {
	default
	newicon src/pics/cup2.png ${PN}.png
	make_desktop_entry ${PN}2 ClanBomber2
	rm -f "${D}/usr/share/${PN}/fonts/DejaVuSans-Bold.ttf" || die
	dosym /usr/share/fonts/dejavu/DejaVuSans-Bold.ttf \
		/usr/share/${PN}/fonts/DejaVuSans-Bold.ttf
}
