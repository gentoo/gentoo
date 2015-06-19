# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/exodusii/exodusii-5.24.ebuild,v 1.2 2013/07/18 23:31:13 zmedico Exp $

EAPI=5

inherit cmake-utils multilib

MY_PN="${PN%ii}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Model developed to store and retrieve transient data for finite element analyses"
HOMEPAGE="http://sourceforge.net/projects/exodusii/"
SRC_URI="mirror://sourceforge/project/${PN}/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"

DEPEND="sci-libs/netcdf"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}/${MY_PN}

PATCHES=( "${FILESDIR}"/${PN}-5.22b-multilib.patch )

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
