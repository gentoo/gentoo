# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Space-shooter written in C++, using the SDL"
HOMEPAGE="http://www.hackl.dhs.org/spacerider/"
SRC_URI="mirror://gentoo/${P}.tar.bz2" # stupid php script

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-gfx
	media-libs/sdl-mixer
	media-libs/sdl-image[jpeg]
	media-libs/sdl-net
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eapply "${FILESDIR}/${P}"-gentoo.patch \
		"${FILESDIR}/${P}"-gcc41.patch \
		"${FILESDIR}"/${P}-ovflfix.patch \
		"${FILESDIR}"/${P}-gcc49.patch \
		"${FILESDIR}"/${P}-font.patch
	sed -i \
		-e "s:/usr/share/games/spacerider:/usr/share/${PN}:" \
		globals.cpp || die
}

src_install() {
	dobin ${PN}
	insinto "/usr/share/${PN}"
	doins -r data
	einstalldocs
	newman ${PN}.{1,6}
	newicon data/sprites/star_monster1/1.bmp ${PN}.bmp
	make_desktop_entry ${PN} Spacerider /usr/share/pixmaps/${PN}.bmp
}
