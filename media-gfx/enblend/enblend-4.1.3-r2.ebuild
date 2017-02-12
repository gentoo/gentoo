# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

MY_P="${PN}-enfuse-${PV}"

DESCRIPTION="Image Blending with Multiresolution Splines"
HOMEPAGE="http://enblend.sourceforge.net/"
SRC_URI="mirror://sourceforge/enblend/${MY_P}.tar.gz"

LICENSE="GPL-2 VIGRA"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc gpu openmp"

RDEPEND="
	dev-libs/boost:=
	media-libs/lcms:2
	media-libs/openexr:=
	media-libs/tiff:=
	media-libs/vigra[openexr]
	sci-libs/gsl:=
	debug? ( dev-libs/dmalloc )
	gpu? (
		media-libs/freeglut
		media-libs/glew:*
		virtual/glu
		virtual/opengl
	)"
DEPEND="${RDEPEND}
	media-libs/libpng:0
	sys-apps/help2man
	virtual/jpeg:0
	virtual/pkgconfig
	doc? (
		media-gfx/transfig
		sci-visualization/gnuplot[gd]
		virtual/imagemagick-tools
		virtual/latex-base
	)"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS NEWS README )

PATCHES=(
	"${FILESDIR}"/${P}-vigra_check.patch
	"${FILESDIR}"/${P}-texinfo-5-upstream.patch
	"${FILESDIR}"/${P}-texinfo-5-more.patch
	"${FILESDIR}"/${P}-cmake.patch
)

src_prepare() {
	cmake-utils_src_prepare

	# CRLF in files, don't bother with patch
	sed -i -e "/FIND_LIBRARY(LCMS2_LIBRARIES/s/lib32/lib/" \
		CMakeModules/FindLCMS2.cmake || die
	sed -e "/FIND_LIBRARY(OPENGL_gl_LIBRARY/s/lib32/lib/" \
		-e "/NAMES.*MesaGLU/s/lib32/lib/" \
		-i CMakeModules/FindOpenGL.cmake || die

	sed -i -e "/CXX_FLAGS/s:-O3::g" CMakeLists.txt || die
	sed -i -e "s:doc/enblend:share/doc/${PF}:" doc/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_CXX_FLAGS_RELEASE=""
		-DENABLE_DMALLOC=$(usex debug)
		-DDOC=$(usex doc)
		-DENABLE_GPU=$(usex gpu)
		-DENABLE_IMAGECACHE=$(usex !openmp)
		-DENABLE_OPENMP=$(usex openmp)
	)
	CMAKE_BUILD_TYPE="Release"
	cmake-utils_src_configure
}

src_compile() {
	# forcing -j1 as every parallel compilation process needs about 1 GB RAM.
	cmake-utils_src_compile -j1
}
