# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils flag-o-matic python-single-r1

DESCRIPTION="Advanced molecular editor that uses Qt4 and OpenGL"
HOMEPAGE="http://avogadro.openmolecules.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+glsl python cpu_flags_x86_sse2 test"

RDEPEND="
	>=sci-chemistry/openbabel-2.3.0
	>=dev-qt/qtgui-4.8.5:4
	>=dev-qt/qtopengl-4.8.5:4
	x11-libs/gl2ps
	glsl? ( >=media-libs/glew-1.5.0 )
	python? (
		>=dev-libs/boost-1.35.0-r5[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/sip[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-cpp/eigen"

# https://sourceforge.net/p/avogadro/bugs/653/
RESTRICT="test"

PATCHES=(
	#"${FILESDIR}"/${PN}-1.1.0-textrel.patch
	"${FILESDIR}"/${PN}-1.1.0-xlibs.patch
	"${FILESDIR}"/${P}-eigen3.patch
	"${FILESDIR}"/${P}-mkspecs-dir.patch
	"${FILESDIR}"/${P}-no-strip.patch
	"${FILESDIR}"/${P}-pkgconfig_eigen.patch
	"${FILESDIR}"/${P}-openbabel.patch
	"${FILESDIR}"/${P}-boost-join-moc.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	sed \
		-e 's:_BSD_SOURCE:_DEFAULT_SOURCE:g' \
		-i CMakeLists.txt || die
	# warning: "Eigen2 support is deprecated in Eigen 3.2.x and it will be removed in Eigen 3.3."
	append-cppflags -DEIGEN_NO_EIGEN2_DEPRECATED_WARNING
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_THREADEDGL=OFF
		-DENABLE_RPATH=OFF
		-DENABLE_UPDATE_CHECKER=OFF
		-DQT_MKSPECS_DIR="${EPREFIX}/usr/share/qt4/mkspecs"
		-DQT_MKSPECS_RELATIVE=share/qt4/mkspecs
		-DENABLE_glsl="$(usex glsl)"
		-DENABLE_TESTS="$(usex test)"
		-DWITH_SSE2="$(usex cpu_flags_x86_sse2)"
		-DENABLE_python="$(usex python)"
	)

	cmake-utils_src_configure
}
