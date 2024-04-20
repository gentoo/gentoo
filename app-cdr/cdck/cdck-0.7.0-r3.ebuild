# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Measure the read time per sector on CD or DVD to check the quality"
HOMEPAGE="http://swaj.net/unix/index.html#cdck"
SRC_URI="http://swaj.net/unix/cdck/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-man.patch
	"${FILESDIR}"/${P}-wording.patch
	"${FILESDIR}"/${P}-automake.patch
	"${FILESDIR}"/${P}-cross.patch
	"${FILESDIR}"/${P}-gcc-10.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
