# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="Clone of the 1982 BurgerTime video game by Data East"
HOMEPAGE="http://perso.b2b2c.ca/~sarrazip/dev/burgerspace.html"
SRC_URI="http://perso.b2b2c.ca/~sarrazip/dev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test" # doesn't really test anything

RDEPEND=">=dev-games/flatzebra-0.2.0
	media-libs/libsdl[joystick]
	media-libs/sdl-image
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
