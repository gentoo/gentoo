# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop toolchain-funcs

DESCRIPTION="2D platform game"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://dev.gentoo.org/~chewi/distfiles/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/opengl
	virtual/glu
	media-libs/sdl-mixer
	media-libs/libsdl[joystick]
	media-libs/sdl-ttf
	media-libs/sdl-image
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}-src"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-gcc44.patch
	"${FILESDIR}"/${P}-underlink.patch
	"${FILESDIR}"/${P}-gcc-11.patch
)

src_compile() {
	tc-export AR CXX
	emake -C JLib
	emake -C src HC_BASE=/usr/share/${PN}/
}

src_install() {
	dobin holotz-castle holotz-castle-editor
	insinto /usr/share/${PN}/game
	doins -r res/*
	insinto /usr/share/${PN}/editor
	doins -r HCedHome/res/*
	newicon res/icon/icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} "Holotz's Castle" /usr/share/pixmaps/${PN}.bmp
	make_desktop_entry ${PN}-editor "Holotz's Castle - Editor" \
		/usr/share/pixmaps/${PN}.bmp
	dodoc doc/MANUAL*.txt
	doman man/*.6
}
