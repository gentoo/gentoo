# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"

inherit autotools gnome2

DESCRIPTION="A fly-eating frog video game"
HOMEPAGE="https://perso.b2b2c.ca/~sarrazip/dev/batrachians.html"
SRC_URI="https://perso.b2b2c.ca/~sarrazip/dev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-games/flatzebra-0.1.5"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_install() {
	emake -C src DESTDIR="${D}" install
	doman doc/${PN}.6
	einstalldocs
}
