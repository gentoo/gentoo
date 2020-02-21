# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="A rampart-like game set in space"
HOMEPAGE="http://kombat.kajaani.net/"
SRC_URI="http://kombat.kajaani.net/dl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-net
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	media-libs/sdl-mixer[vorbis]
	sys-libs/ncurses:0
	sys-libs/readline:0
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eapply "${FILESDIR}/${PV}-makefile.patch" \
		"${FILESDIR}"/${P}-ldflags.patch
	sed -i \
		-e "s:GENTOODIR:/usr/share/${PN}/:" \
		Makefile || die
	sed -i \
		-e 's/IMG_Load/img_load/' \
		gui_screens.cpp || die
}

src_install() {
	dobin kajaani-kombat
	insinto "/usr/share/${PN}"
	doins *.{png,ttf,ogg}
	einstalldocs
	doman kajaani-kombat.6
}
