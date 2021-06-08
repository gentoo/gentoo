# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Clone of the 1981 Night Stalker video game by Mattel Electronics"
HOMEPAGE="http://perso.b2b2c.ca/~sarrazip/dev/afternoonstalker.html"
SRC_URI="http://perso.b2b2c.ca/~sarrazip/dev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-games/flatzebra-0.1.6"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-1.1.6-autotools.patch )

src_prepare() {
	default
	eautoreconf
}
