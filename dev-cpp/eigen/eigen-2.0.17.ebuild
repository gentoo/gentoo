# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="C++ template library for linear algebra"
HOMEPAGE="http://eigen.tuxfamily.org/"
SRC_URI="https://bitbucket.org/eigen/eigen/get/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE="debug doc examples test"
# bugs 426236, 455460, 467288
RESTRICT="test"

RDEPEND="
	examples? (
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
	)
	!dev-cpp/eigen:0"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	mv ${PN}* ${P} || die
}

src_configure() {
	# benchmarks (BTL) brings up a damn load of external deps including fortran
	# library hangs up complete compilation proccess, test later
	local mycmakeargs=(
		-DEIGEN_BUILD_LIB=OFF
		-DEIGEN_BUILD_BTL=OFF
		-DEIGEN_BUILD_PKGCONFIG=ON
		-DEIGEN_BUILD_DEMOS=$(usex examples)
		-DEIGEN_BUILD_TESTS=$(usex test)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile -j1

	if use doc; then
		cmake-utils_src_compile -j1 doc
		HTML_DOCS=( "${BUILD_DIR}"/html/. )
	fi
}

src_install() {
	cmake-utils_src_install -j1

	if use examples; then
		cd "${BUILD_DIR}"/demos || die
		dobin mandelbrot/mandelbrot opengl/quaternion_demo
	fi
}
