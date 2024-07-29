# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="An exciting Brick Breaker"
HOMEPAGE="https://linux.tlk.fr/games/TecnoballZ/"
SRC_URI="https://github.com/brunonymous/tecnoballz/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/tinyxml
	media-libs/libsdl[joystick]
	media-libs/sdl-mixer[mikmod]
	media-libs/sdl-image[png]
	media-libs/libmikmod:0"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	mkdir man/fr || die
	mv man/${PN}.fr.6 man/fr/${PN}.6 || die

	sed -i -e 's:\$(prefix)/games:\$(prefix)/bin:' src/Makefile.am || die
	sed -i -e '/CXXFLAGS=/d' -e '/^else/d' configure.ac || die

	eautoreconf
}

src_install() {
	default
	make_desktop_entry ${PN} Tecnoballz
}
