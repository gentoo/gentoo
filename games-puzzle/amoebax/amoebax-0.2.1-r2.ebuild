# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Cute and addictive action-puzzle game, similar to tetris"
HOMEPAGE="https://www.emma-soft.com/games/amoebax/"
SRC_URI="https://www.emma-soft.com/games/amoebax/download/${P}.tar.bz2"

LICENSE="Free-Art-1.2 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-aclocal.patch
	"${FILESDIR}"/${P}-clang.patch
	"${FILESDIR}"/${P}-compile.patch
)

src_prepare() {
	default

	sed -i \
		-e "/^SUBDIRS/s|doc ||" \
		Makefile.am || die
	sed -i \
		-e '/Encoding/d' \
		-e '/Icon/s/.svg//' \
		data/amoebax.desktop || die

	AT_M4DIR=m4 eautoreconf
}
