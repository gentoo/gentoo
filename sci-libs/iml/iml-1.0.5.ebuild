# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Integer Matrix Library"
HOMEPAGE="http://www.cs.uwaterloo.ca/~astorjoh/iml.html"
SRC_URI="http://www.cs.uwaterloo.ca/~astorjoh/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RESTRICT="mirror"

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
