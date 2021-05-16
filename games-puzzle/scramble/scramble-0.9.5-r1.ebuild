# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop flag-o-matic

DESCRIPTION="Create as many words as you can before the time runs out"
HOMEPAGE="http://www.shiftygames.com/scramble/scramble.html"
SRC_URI="http://www.shiftygames.com/scramble/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=media-libs/libsdl-1.2[sound,video]
	>=media-libs/sdl-mixer-1.2[vorbis]
	>=media-libs/sdl-image-1.2[png]
	media-libs/sdl-ttf
"
DEPEND="${RDEPEND}
	media-libs/libpng:0
	sys-apps/miscfiles
"

src_prepare() {
	default
	pngfix -q --out=pics/background-fixed.png pics/background.png
	mv -f pics/background-fixed.png pics/background.png
	append-cflags $(sdl-config --cflags)
	sed -i -e 's/inline //' src/scramble.c || die
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default
	newicon pics/sg_icon.png ${PN}.png
	make_desktop_entry ${PN} "Scramble"
}
