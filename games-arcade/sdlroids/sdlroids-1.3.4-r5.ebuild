# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="Asteroids Clone for X using SDL"
HOMEPAGE="http://david.hedbor.org/projects/sdlroids/"
SRC_URI="mirror://sourceforge/sdlroids/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[joystick]
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-sound.patch
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default

	newicon icons/sdlroids-48x48.xpm ${PN}.xpm
	make_desktop_entry ${PN} SDLRoids ${PN}
}
