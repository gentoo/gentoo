# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/exodusii/exodusii-5.22b.ebuild,v 1.4 2012/12/13 14:52:24 jlec Exp $

EAPI=4

inherit cmake-utils multilib

DESCRIPTION="Model developed to store and retrieve transient data for finite element analyses"
HOMEPAGE="http://sourceforge.net/projects/exodusii/"
SRC_URI="mirror://sourceforge/${PN}/${P/ii/}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"

DEPEND="sci-libs/netcdf"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${P/ii/}/${PN/ii/}

PATCHES=( "${FILESDIR}"/${P}-multilib.patch )

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DLIB_INSTALL_DIR=$(get_libdir)
		-DNETCDF_DIR="${EPREFIX}/usr/"
		$(cmake-utils_use !static-libs BUILD_SHARED_LIBS)
		$(cmake-utils_use test BUILD_TESTING)"
	cmake-utils_src_configure
}

src_test() {
	cd "${BUILD_DIR}"/forbind/test
	csh testall
	./f_test_nem || die
}
