# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/qd/qd-2.3.14.ebuild,v 1.1 2013/05/31 12:30:18 jlec Exp $

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
		$(use_enable fortran enable_fortran)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	use doc || rm "${ED}"/usr/share/doc/${PF}/*.pdf
	dosym qd_real.h /usr/include/qd/qd.h
	dosym dd_real.h /usr/include/qd/dd.h
}
