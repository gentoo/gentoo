# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A C++ framework for evolutionary computing"
HOMEPAGE="http://www.coyotegulch.com/products/libevocosm/"
SRC_URI="http://www.coyotegulch.com/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="dev-libs/libcoyotl
	dev-libs/libbrahe"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog NEWS README )

PATCHES=(
	"${FILESDIR}"/${P}-gcc47.patch
)

src_configure() {
	export ac_cv_prog_HAVE_DOXYGEN="false"
	econf --disable-static
}

src_compile() {
	emake

	if use doc ; then
		cd docs || die
		doxygen libevocosm.doxygen || die "generating docs failed"
	fi
}

src_install() {
	default

	if use doc ; then
		docinto html
		dodoc docs/html/*
	fi

	find "${ED}" -name '*.la' -delete || die
}
