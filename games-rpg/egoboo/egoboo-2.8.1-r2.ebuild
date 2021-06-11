# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="3D dungeon crawling adventure in the spirit of NetHack"
HOMEPAGE="http://egoboo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-games/physfs
	media-libs/libsdl[joystick,opengl,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	net-libs/enet:1.3=
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-enet-1.3.patch
	"${FILESDIR}"/${P}-keyboard-inputs.patch
)

src_prepare() {
	default

	sed -e "s|@GENTOO_CONFDIR@|${EPREFIX}/etc/${PN}|" \
		-e "s|@GENTOO_DATADIR@|${EPREFIX}/usr/share/${PN}|" \
		-i src/game/platform/file_linux.c || die
}

src_compile() {
	emake -C src/game PROJ_NAME=egoboo-2.x CC="$(tc-getCC)"
}

src_install() {
	newbin src/game/egoboo-2.x ${PN}

	dodoc BUGS.txt Changelog.txt doc/*.{txt,pdf}

	insinto /usr/share/${PN}
	doins -r basicdat modules

	insinto /etc/${PN}
	doins controls.txt setup.txt

	make_desktop_entry ${PN} Egoboo applications-games "Game;"
}
