# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop toolchain-funcs

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

PATCHES=(
	"${FILESDIR}"/${PV}-makefile.patch
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	default

	sed -i \
		-e "s:GENTOODIR:/usr/share/${PN}/:" \
		Makefile || die
	sed -i \
		-e 's/IMG_Load/img_load/' \
		gui_screens.cpp || die

	tc-export CXX
}

src_install() {
	dobin kajaani-kombat
	insinto "/usr/share/${PN}"
	doins *.{png,ttf,ogg}
	einstalldocs
	doman kajaani-kombat.6
}
