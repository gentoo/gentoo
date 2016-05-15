# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

FORTRAN_NEEDED="test"

inherit cmake-utils fortran-2 multilib

MY_PN="${PN%ii}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Model developed to store and retrieve transient data for finite element analyses"
HOMEPAGE="http://sourceforge.net/projects/exodusii/"
SRC_URI="mirror://sourceforge/project/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"

RDEPEND="sci-libs/netcdf[hdf5]"
DEPEND="${RDEPEND}
	test? ( app-shells/tcsh )
"

S="${WORKDIR}"/${MY_P}/${MY_PN}

PATCHES=( "${FILESDIR}"/${PN}-5.26-multilib.patch )

src_prepare() {
	use test || \
		sed \
		-e 's:Fortran::g' \
		-i CMakeLists.txt || die
	cmake-utils_src_prepare
}

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
	cd "${BUILD_DIR}"/cbind/test || die
	ctest || die
	cd "${BUILD_DIR}"/forbind/test || die
	emake f_check
}
