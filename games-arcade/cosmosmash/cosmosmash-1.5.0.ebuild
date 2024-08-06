# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Space rock shooting video game"
HOMEPAGE="https://perso.b2b2c.ca/~sarrazip/dev/cosmosmash.html"
SRC_URI="http://perso.b2b2c.ca/~sarrazip/dev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test" # uses the sound card which portage user might not be available.

RDEPEND=">=dev-games/flatzebra-0.2.0
	media-libs/libsdl[joystick]
	media-libs/sdl-image
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed -i \
		-e "/^pkgsounddir/ s:sounds.*:\$(PACKAGE)/sounds:" \
		-e "/^desktopentrydir/ s:=.*:=/usr/share/applications:" \
		-e "/^pixmapdir/ s:=.*:=/usr/share/pixmaps:" \
		src/Makefile.am \
		|| die

	eautoreconf
}

src_install() {
	emake -C src DESTDIR="${D}" install

	einstalldocs
	doman doc/${PN}.6
}
