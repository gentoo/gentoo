# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop

DESCRIPTION="A 3d dungeon crawling adventure in the spirit of NetHack"
HOMEPAGE="http://egoboo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-games/physfs
	media-libs/libsdl[joystick,video]
	media-libs/sdl-image
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	net-libs/enet:0
	virtual/glu
	virtual/opengl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default
	sed -i \
		-e "s:@GENTOO_CONFDIR@:/etc/${PN}:" \
		-e "s:@GENTOO_DATADIR@:/usr/share/${PN}:" \
		src/game/platform/file_linux.c || die "sed failed"
	rm -rf src/enet || die
}

src_compile() {
	emake -C src/game PROJ_NAME=egoboo-2.x
}

src_install() {
	dodoc BUGS.txt Changelog.txt doc/*.txt doc/*.pdf

	insinto /usr/share/${PN}
	doins -r basicdat modules
	insinto /etc/${PN}
	doins -r controls.txt setup.txt

	newbin src/game/egoboo-2.x ${PN}

	newicon basicdat/icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} Egoboo /usr/share/pixmaps/${PN}.bmp
}
