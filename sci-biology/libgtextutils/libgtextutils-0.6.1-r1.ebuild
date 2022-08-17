# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Gordon Text utils Library"
HOMEPAGE="http://hannonlab.cshl.edu/fastx_toolkit/"
SRC_URI="http://hannonlab.cshl.edu/fastx_toolkit/${P}.tar.bz2"

LICENSE="AGPL-3"
SLOT="0/0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-fix-build-system.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
