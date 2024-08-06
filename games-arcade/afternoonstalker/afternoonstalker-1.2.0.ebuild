# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Clone of the 1981 Night Stalker video game by Mattel Electronics"
HOMEPAGE="http://perso.b2b2c.ca/~sarrazip/dev/afternoonstalker.html"
SRC_URI="http://perso.b2b2c.ca/~sarrazip/dev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-games/flatzebra-0.2.0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-1.2.0-autotools.patch )

src_prepare() {
	default
	eautoreconf
}
