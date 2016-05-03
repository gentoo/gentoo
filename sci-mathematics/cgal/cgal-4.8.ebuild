# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils flag-o-matic

MY_P=CGAL-${PV}

DESCRIPTION="C++ library for geometric algorithms and data structures"
HOMEPAGE="http://www.cgal.org/"
SRC_URI="
	https://github.com/CGAL/cgal/releases/download/releases%2F${MY_P}/${MY_P}.tar.xz -> ${P}.tar.xz
	doc? ( https://github.com/CGAL/cgal/releases/download/releases%2F${MY_P}/${MY_P}-doc_html.tar.xz -> ${P}-doc_html-1.tar.xz )"

LICENSE="LGPL-3 GPL-3 Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples +gmp mpfi ntl qt5"

RDEPEND="
	>=dev-cpp/eigen-3.1
	dev-libs/boost:=
	dev-libs/mpfr:0
	sys-libs/zlib
	x11-libs/libX11
	virtual/glu
	virtual/opengl
	gmp? ( dev-libs/gmp[cxx] )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)
	mpfi? ( sci-libs/mpfi )
	ntl? ( dev-libs/ntl )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"
PATCHES=(
	"${FILESDIR}/${PN}-4.7-fix-buildsystem.patch"
)

src_prepare() {
	cmake-utils_src_prepare
	# modules provided by dev-util/cmake and dev-cpp/eigen
	rm cmake/modules/Find{Eigen3,GLEW,OpenGL}.cmake || die
	sed \
		-e '/install(FILES AUTHORS/d' \
		-i CMakeLists.txt || die

	# use C++11 threads instead of boost::thread
	append-cxxflags -std=c++11
}

src_configure() {
	local mycmakeargs=(
		-DCGAL_INSTALL_LIB_DIR=$(get_libdir)
		-DCGAL_INSTALL_CMAKE_DIR="${EPREFIX}/usr/share/cmake/Modules/"
		-DWITH_CGAL_Qt3=OFF
		-DWITH_LEDA=OFF
		-DWITH_Eigen3=ON
		-DWITH_ZLIB=ON
		-DWITH_GMP="$(usex gmp)"
		-DWITH_GMPXX="$(usex gmp)"
		-DWITH_CGAL_Qt5="$(usex qt5)"
		-DWITH_MPFI="$(usex mpfi)"
		-DWITH_NTL="$(usex ntl)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use examples; then
		dodoc -r examples demo
	fi
	if use doc; then
		docinto html/
		dodoc -r "${WORKDIR}"/doc_html/*
	fi
}
