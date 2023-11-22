# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Integer Matrix Library"
HOMEPAGE="https://www.cs.uwaterloo.ca/~astorjoh/iml.html"
SRC_URI="https://www.cs.uwaterloo.ca/~astorjoh/${P}.tar.bz2"

# COPYING is GPL-2, but the files under src/ all have a BSD header
LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="virtual/cblas"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README )

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.4-use-any-cblas-implementation.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-default="${EPREFIX}"/usr \
		--enable-shared \
		$(use_enable static-libs static)
}
