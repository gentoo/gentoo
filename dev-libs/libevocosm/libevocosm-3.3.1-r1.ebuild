# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="A C++ framework for evolutionary computing"
HOMEPAGE="http://www.coyotegulch.com/products/libevocosm/"
SRC_URI="http://www.coyotegulch.com/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"

IUSE="doc static-libs"

RDEPEND="dev-libs/libcoyotl
	dev-libs/libbrahe"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc47.patch"
	epatch_user
}

src_configure() {
	export ac_cv_prog_HAVE_DOXYGEN="false"
	econf $(use_enable static-libs static)
}

src_compile() {
	emake

	if use doc ; then
		cd docs
		doxygen libevocosm.doxygen || die "generating docs failed"
	fi
}

src_install() {
	default
	prune_libtool_files
	use doc && dohtml docs/html/*
}
