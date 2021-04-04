# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GNOME2_EAUTORECONF="yes"
inherit gnome2

DESCRIPTION="A fly-eating frog video game"
HOMEPAGE="https://perso.b2b2c.ca/~sarrazip/dev/batrachians.html"
SRC_URI="https://perso.b2b2c.ca/~sarrazip/dev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-games/flatzebra-0.1.5
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_install() {
	emake -C src DESTDIR="${D}" install
	doman doc/${PN}.6
	einstalldocs
}
