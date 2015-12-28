# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="C++ template library for linear algebra"
HOMEPAGE="http://eigen.tuxfamily.org/"
SRC_URI="https://bitbucket.org/eigen/eigen/get/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="LGPL-2 GPL-3"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug doc"

DEPEND="doc? ( app-doc/doxygen[dot,latex] )"
RDEPEND="!dev-cpp/eigen:0"

src_unpack() {
	default
	mv ${PN}* ${P} || die
}

src_prepare() {
	sed -i CMakeLists.txt \
		-e "/add_subdirectory(demos/d" \
		-e "/add_subdirectory(blas/d" \
		-e "/add_subdirectory(lapack/d" \
		|| die "sed disable unused bundles failed"

	sed -i -e "/Unknown build type/d" CMakeLists.txt || die

	sed \
		-e '/Cflags/s|:.*|: -I${CMAKE_INSTALL_PREFIX}/${INCLUDE_INSTALL_DIR}|g' \
		-i eigen3.pc.in || die

	cmake-utils_src_prepare
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile doc
}

src_test() {
	local mycmakeargs=(
		-DEIGEN_BUILD_TESTS=ON
		-DEIGEN_TEST_NO_FORTRAN=ON
		-DEIGEN_TEST_NO_OPENGL=ON
	)
	cmake-utils_src_configure
	cmake-utils_src_compile buildtests
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc -r "${BUILD_DIR}"/doc/html

	# Debian installs it and some projects started using it.
	insinto /usr/share/cmake/Modules/
	doins "${S}/cmake/FindEigen3.cmake"
}
