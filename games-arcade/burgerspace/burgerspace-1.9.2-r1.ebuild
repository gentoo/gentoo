# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Clone of the 1982 BurgerTime video game by Data East"
HOMEPAGE="https://perso.b2b2c.ca/~sarrazip/dev/burgerspace.html"
SRC_URI="https://perso.b2b2c.ca/~sarrazip/dev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="network"
RESTRICT="test" # doesn't really test anything

RDEPEND=">=dev-games/flatzebra-0.1.6"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-1.9.2-gcc11.patch )

src_prepare() {
	default

	sed -i \
		-e "/^pkgsounddir/ s:sounds.*:\$(PACKAGE)/sounds:" \
		-e "/^desktopentrydir/ s:=.*:=/usr/share/applications:" \
		-e "/^pixmapdir/ s:=.*:=/usr/share/pixmaps:" \
		src/Makefile.am \
		|| die

	sed -i \
		-e "/Categories/s:Application;::" \
		-e "/Icon/s:\..*::" \
		-e "/Terminal/s:0:false:" \
		src/burgerspace.desktop.in \
		|| die

	eautoreconf
}

src_configure() {
	econf \
		$(use_with network)
}

src_install() {
	emake -C src DESTDIR="${D}" install

	doman doc/${PN}.6
	dodoc AUTHORS NEWS README THANKS
}
