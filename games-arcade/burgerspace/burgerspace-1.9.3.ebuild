# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="Clone of the 1982 BurgerTime video game by Data East"
HOMEPAGE="http://perso.b2b2c.ca/~sarrazip/dev/burgerspace.html"
SRC_URI="http://perso.b2b2c.ca/~sarrazip/dev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="network"
RESTRICT="test" # doesn't really test anything

RDEPEND=">=dev-games/flatzebra-0.1.7"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-1.9.3-autotools.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with network)
}
