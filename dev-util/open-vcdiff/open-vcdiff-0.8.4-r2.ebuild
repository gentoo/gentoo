# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An encoder/decoder for the VCDIFF (RFC3284) format"
HOMEPAGE="https://github.com/google/open-vcdiff"
SRC_URI="https://dev.gentoo.org/~floppym/dist/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${P}-gcc6.patch )

src_prepare() {
	sed -i -e "s|^docdir =.*|docdir = \"${EPREFIX}/usr/share/doc/${PF}\"|g" \
		Makefile.in || die
	default
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
