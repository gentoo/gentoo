# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_BUILD_TYPE=Release

inherit multilib cmake-utils

MY_P=CGAL-${PV}
PID=32995
DPID=33000

DESCRIPTION="C++ library for geometric algorithms and data structures"
HOMEPAGE="http://www.cgal.org/ https://gforge.inria.fr/projects/cgal/"
SRC_URI="
	http://gforge.inria.fr/frs/download.php/${PID}/${MY_P}.tar.xz
	doc? ( http://gforge.inria.fr/frs/download.php/${DPID}/${MY_P}-doc_html.tar.xz )"

LICENSE="LGPL-3 GPL-3 Boost-1.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples +gmp mpfi qt4"

RDEPEND="
	dev-libs/boost
	dev-libs/mpfr:0
	sys-libs/zlib
	x11-libs/libX11
	virtual/glu
	virtual/opengl
	gmp? ( dev-libs/gmp[cxx] )
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
	)
	mpfi? ( sci-libs/mpfi )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

DOCS="AUTHORS CHANGES* README"

src_prepare() {
	cmake-utils_src_prepare
	sed \
		-e '/install(FILES AUTHORS/d' \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs+=(
		-DCGAL_INSTALL_LIB_DIR=$(get_libdir)
		-DWITH_CGAL_Qt3=OFF
		-DWITH_LEDA=OFF
		$(cmake-utils_use_with gmp)
		$(cmake-utils_use_with gmp GMPXX)
		$(cmake-utils_use_with qt4 CGAL_Qt4)
		$(cmake-utils_use_with mpfi)
	)
	cmake-utils_src_configure
}

src_install() {
	use doc && HTML_DOCS=( "${WORKDIR}"/doc_html/. )
	cmake-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples demo
	fi
}
