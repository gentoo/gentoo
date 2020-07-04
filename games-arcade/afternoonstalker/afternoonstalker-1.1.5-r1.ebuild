# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Clone of the 1981 Night Stalker video game by Mattel Electronics"
HOMEPAGE="https://perso.b2b2c.ca/~sarrazip/dev/afternoonstalker.html"
SRC_URI="https://perso.b2b2c.ca/~sarrazip/dev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-games/flatzebra-0.1.6"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	sed -i \
		-e "/^pkgsounddir/ s:sounds.*:\$(PACKAGE)/sounds:" \
		-e "/^desktopentrydir/ s:=.*:=/usr/share/applications:" \
		-e "/^pixmapdir/ s:=.*:=/usr/share/pixmaps:" \
		src/Makefile.am || die
	eautoreconf
}

src_install() {
	emake -C src DESTDIR="${D}" install
	doman doc/${PN}.6
	einstalldocs
}
