# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/spqr/spqr-1.2.3.ebuild,v 1.2 2012/05/04 08:22:54 jdhore Exp $

EAPI=4
AUTOTOOLS_AUTORECONF=yes
inherit autotools-utils

MY_PN=SPQR
DESCRIPTION="Multithreaded multifrontal sparse QR factorization library"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/SPQR"
SRC_URI="http://www.cise.ufl.edu/research/sparse/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc metis static-libs tbb"
RDEPEND="sci-libs/cholmod[supernodal]
	tbb? ( dev-cpp/tbb )
	metis? ( >=sci-libs/cholmod-1.7.0-r1[metis] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( README.txt Doc/ChangeLog )
PATCHES=( "${FILESDIR}"/${P}-autotools.patch )

S="${WORKDIR}/${MY_PN}"

src_configure() {
	myeconfargs+=(
		$(use_with metis)
		$(use_with tbb)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use doc && doins Doc/*.pdf
}
