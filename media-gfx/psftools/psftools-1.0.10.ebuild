# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Utilities for manipulation of console fonts in PSF format"
HOMEPAGE="https://www.seasip.info/Unix/PSF/"
SRC_URI="https://www.seasip.info/Unix/PSF/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

DEPEND=""
RDEPEND=""

DOCS="AUTHORS NEWS TODO doc/*.txt"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${ED}"/usr -name '*.la' -delete
}
