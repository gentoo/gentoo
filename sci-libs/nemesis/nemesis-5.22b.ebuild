# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils multilib

MY_PN="exodus"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Enhancement to the EXODUSII finite element database model"
HOMEPAGE="http://sourceforge.net/projects/exodusii/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"

DEPEND="
	sci-libs/exodusii
	sci-libs/netcdf"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}/${PN}

PATCHES=( "${FILESDIR}"/${P}-multilib.patch )

src_prepare() {
	find ../exodus -delete || die
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DLIB_INSTALL_DIR=$(get_libdir)
		-DNETCDF_DIR="${EPREFIX}/usr/"
		-DEXODUS_DIR="${EPREFIX}/usr/"
		$(cmake-utils_use !static-libs BUILD_SHARED_LIBS)
		$(cmake-utils_use test BUILD_TESTING)"
	cmake-utils_src_configure
}

src_test() {
	"${BUILD_DIR}"/ne_test || die
}
