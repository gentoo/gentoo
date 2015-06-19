# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/exodusii/exodusii-5.26.ebuild,v 1.1 2014/01/01 14:35:18 jlec Exp $

EAPI=5

inherit cmake-utils multilib

MY_PN="${PN%ii}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Model developed to store and retrieve transient data for finite element analyses"
HOMEPAGE="http://sourceforge.net/projects/exodusii/"
SRC_URI="mirror://sourceforge/project/${PN}/${MY_P}-1.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"

DEPEND="sci-libs/netcdf[hdf5]"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}/

PATCHES=( "${FILESDIR}"/${P}-multilib.patch )

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR=$(get_libdir)
		-DNETCDF_DIR="${EPREFIX}/usr/"
		$(cmake-utils_use_build !static-libs SHARED)
		$(cmake-utils_use_build test TESTING)
	)
	cmake-utils_src_configure
}

src_test() {
	cd "${BUILD_DIR}"/forbind/test || die
	csh testall || die
	./f_test_nem || die
}
