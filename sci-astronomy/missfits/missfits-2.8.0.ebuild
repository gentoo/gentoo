# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Performs basic maintenance and packaging tasks on FITS files"
HOMEPAGE="http://www.astromatic.net/software/missfits/"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-run-AM_PROG_AR.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	dodoc -r doc/.
}
