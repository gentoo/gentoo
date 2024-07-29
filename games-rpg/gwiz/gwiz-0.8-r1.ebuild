# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs autotools

DESCRIPTION="Clone of old-school Wizardry(tm) games by SirTech"
HOMEPAGE="https://icculus.org/gwiz/"
SRC_URI="https://icculus.org/gwiz/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl[joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-buffer.patch
)

src_prepare() {
	default

	tc-export CC
	append-cflags -std=gnu89 # build with gcc5 (bug #572532)
	eautoreconf # fixes configure problems for free (bug #880811)
}

src_install() {
	default

	dodoc doc/HOWTO-PLAY
	newicon pixmaps/gwiz_icon.xpm ${PN}.xpm
	make_desktop_entry gwiz Gwiz
}
