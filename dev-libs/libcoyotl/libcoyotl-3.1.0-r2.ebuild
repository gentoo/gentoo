# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils autotools

DESCRIPTION="A collection of portable C++ classes"
HOMEPAGE="http://www.coyotegulch.com/products/libcoyotl/"
SRC_URI="http://www.coyotegulch.com/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"

IUSE="doc static-libs"

RDEPEND="media-libs/libpng:0="
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	epatch "${FILESDIR}/${PV}-gcc-4.3.patch"
	epatch "${FILESDIR}/${PV}-gcc-4.7.patch"
	epatch_user
	eautoreconf
}

src_configure() {
	ac_cv_prog_HAVE_DOXYGEN="false" econf $(use_enable static-libs static)
}

src_compile() {
	emake

	if use doc ; then
		cd docs
		doxygen libcoyotl.doxygen || die "generating docs failed"
	fi
}

src_install() {
	default
	prune_libtool_files
	if use doc ; then
		dohtml docs/html/*
	fi
}
