# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_P=CGAL-${PV}
DESCRIPTION="C++ library for geometric algorithms and data structures"
HOMEPAGE="https://www.cgal.org/"
SRC_URI="
	https://github.com/CGAL/cgal/releases/download/v${PV}/${MY_P}.tar.xz
	doc? ( https://github.com/CGAL/cgal/releases/download/v${PV}/${MY_P}-doc_html.tar.xz )"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-3 GPL-3 Boost-1.0"
SLOT="0/14"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples +gmp mpfi ntl qt5 +shared"

RDEPEND="
	dev-cpp/eigen
	dev-libs/boost:=
	dev-libs/mpfr:=
	sys-libs/zlib
	x11-libs/libX11:=
	virtual/glu:=
	virtual/opengl:=
	gmp? ( dev-libs/gmp:=[cxx] )
	mpfi? ( sci-libs/mpfi )
	ntl? ( dev-libs/ntl )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${PN}-4.11.1-fix-buildsystem.patch )

src_prepare() {
	cmake_src_prepare
	# modules provided by dev-cpp/eigen
	rm cmake/modules/FindEigen3.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DCGAL_INSTALL_LIB_DIR="$(get_libdir)"
		-DCGAL_INSTALL_CMAKE_DIR="$(get_libdir)/cmake/CGAL"
		-DCGAL_HEADER_ONLY=$(usex shared OFF ON)
		-DWITH_LEDA=OFF
		-DWITH_Eigen3=ON
		-DWITH_ZLIB=ON
		-DWITH_GMP=$(usex gmp)
		-DWITH_GMPXX=$(usex gmp)
		-DWITH_MPFI=$(usex mpfi)
		-DWITH_NTL=$(usex ntl)
		-DWITH_CGAL_Qt5=$(usex qt5)
	)
	cmake_src_configure
}

src_install() {
	use doc && local HTML_DOCS=( "${WORKDIR}"/doc_html/. )
	cmake_src_install
	if use examples; then
		dodoc -r examples demo
	fi
}
