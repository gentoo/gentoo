# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An encoder/decoder for the VCDIFF (RFC3284) format"
HOMEPAGE="https://github.com/google/open-vcdiff"
SRC_URI="https://dev.gentoo.org/~floppym/dist/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=( "${FILESDIR}"/${P}-gcc6.patch )

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
