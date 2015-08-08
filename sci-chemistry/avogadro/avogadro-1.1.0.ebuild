# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils eutils python-single-r1

DESCRIPTION="Advanced molecular editor that uses Qt4 and OpenGL"
HOMEPAGE="http://avogadro.openmolecules.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+glsl python cpu_flags_x86_sse2 test"

RDEPEND="
	>=sci-chemistry/openbabel-2.3.0
	>=dev-qt/qtgui-4.5.3:4
	>=dev-qt/qtopengl-4.5.3:4
	x11-libs/gl2ps
	glsl? ( >=media-libs/glew-1.5.0 )
	python? (
		>=dev-libs/boost-1.35.0-r5[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/sip[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	dev-cpp/eigen:2"

# https://sourceforge.net/p/avogadro/bugs/653/
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${P}-textrel.patch
	"${FILESDIR}"/${P}-xlibs.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_THREADGL=OFF
		-DENABLE_RPATH=OFF
		-DENABLE_UPDATE_CHECKER=OFF
		-DQT_MKSPECS_DIR="${EPREFIX}/usr/share/qt4/mkspecs"
		-DQT_MKSPECS_RELATIVE=share/qt4/mkspecs
		$(cmake-utils_use_enable glsl)
		$(cmake-utils_use_enable test TESTS)
		$(cmake-utils_use_with cpu_flags_x86_sse2 SSE2)
		$(cmake-utils_use_enable python)
	)

	cmake-utils_src_configure
}
