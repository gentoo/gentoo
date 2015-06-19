# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/enblend/enblend-4.1.2.ebuild,v 1.2 2014/06/15 12:34:05 maekke Exp $

EAPI=5

inherit cmake-utils

MY_P="${PN}-enfuse-${PV/_rc/rc}"

DESCRIPTION="Image Blending with Multiresolution Splines"
HOMEPAGE="http://enblend.sourceforge.net/"
SRC_URI="mirror://sourceforge/enblend/${MY_P}.tar.gz"

LICENSE="GPL-2 VIGRA"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc gpu image-cache openmp"

REQUIRED_USE="openmp? ( !image-cache )"

RDEPEND="
	media-libs/glew
	=media-libs/lcms-2*
	>=media-libs/libpng-1.2.43:0=
	>=media-libs/openexr-1.0:=
	media-libs/plotutils[X]
	media-libs/tiff
	>=media-libs/vigra-1.8.0
	sci-libs/gsl
	virtual/jpeg:0=
	debug? ( dev-libs/dmalloc )
	gpu? ( media-libs/freeglut )"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.31.0:=
	sys-apps/help2man
	virtual/pkgconfig
	doc? (
		media-gfx/imagemagick
		media-gfx/transfig
		sci-visualization/gnuplot[gd]
		virtual/latex-base
	)"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i -e "/CXX_FLAGS/s:-O3::g" CMakeLists.txt || die
	sed -i -e "s:doc/enblend:doc/${P}:" doc/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_CXX_FLAGS_RELEASE=""
		$(cmake-utils_use_enable debug DMALLOC)
		$(cmake-utils_use doc DOC)
		$(cmake-utils_use_enable image-cache IMAGECACHE)
		$(cmake-utils_use_enable openmp)
		$(cmake-utils_use_enable gpu)
	)
	CMAKE_BUILD_TYPE="Release"
	cmake-utils_src_configure
}

src_compile() {
	# forcing -j1 as every parallel compilation process needs about 1 GB RAM.
	cmake-utils_src_compile -j1
}

src_install() {
	local DOCS=( AUTHORS ChangeLog NEWS README )
	cmake-utils_src_install
}
