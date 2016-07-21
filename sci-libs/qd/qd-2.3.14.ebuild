# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes

FORTRAN_NEEDED=fortran

inherit autotools-utils fortran-2

DESCRIPTION="Quad-double and double-double float arithmetics"
HOMEPAGE="http://crd.lbl.gov/~dhbailey/mpdist/"
SRC_URI="http://crd.lbl.gov/~dhbailey/mpdist/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc fortran static-libs"

PATCHES=( "${FILESDIR}"/${PN}-2.3.13-autotools.patch )

src_configure() {
	local myeconfargs=(
		$(use_enable fortran)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	use doc || rm "${ED}"/usr/share/doc/${PF}/*.pdf
	dosym qd_real.h /usr/include/qd/qd.h
	dosym dd_real.h /usr/include/qd/dd.h
}
