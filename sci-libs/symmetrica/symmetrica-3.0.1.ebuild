# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C library for representation theory, combinatorics, and more"
HOMEPAGE="https://gitlab.com/sagemath/symmetrica"
SRC_URI="https://gitlab.com/sagemath/symmetrica/uploads/b3d8e1ad5ab2449c30bbc3147e7a5e53/${P}.tar.xz"

LICENSE="ISC"
SLOT="0/2"
KEYWORDS="amd64"
IUSE="doc"

DOCS=( README.md )

src_configure() {
	econf $(use_enable doc)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
