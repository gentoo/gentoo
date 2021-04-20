# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A collection of portable C++ classes"
HOMEPAGE="http://www.coyotegulch.com/products/libcoyotl/"
SRC_URI="http://www.coyotegulch.com/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="media-libs/libpng:0="
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog NEWS README )

PATCHES=(
	"${FILESDIR}"/${PV}-gcc-4.3.patch
	"${FILESDIR}"/${PV}-gcc-4.7.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	ac_cv_prog_HAVE_DOXYGEN="false" econf --disable-static
}

src_compile() {
	emake

	if use doc ; then
		cd docs || die
		doxygen libcoyotl.doxygen || die "generating docs failed"
	fi
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	if use doc ; then
		docinto html
		dodoc docs/html/*
	fi
}
