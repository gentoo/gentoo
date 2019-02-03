# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils flag-o-matic

DESCRIPTION="Panorama viewer (Quicktime, PangeaVR, GLPanoView formats)"
HOMEPAGE="http://freepv.sourceforge.net/"
SRC_URI="mirror://sourceforge/freepv/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/libxml2
	media-libs/libpng:0=
	media-libs/freeglut
	sys-libs/zlib
	virtual/jpeg:0
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXxf86vm"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc44.patch
	"${FILESDIR}"/${P}-gcc46.patch
	"${FILESDIR}"/${P}-noplugin.patch
	"${FILESDIR}"/${P}-libpng14.patch
	"${FILESDIR}"/${P}-stringh.patch
	"${FILESDIR}"/${P}-unsigned_short.patch
)

src_prepare() {
	cmake-utils_src_prepare

	sed -e 's:jpeg_mem_src:freepv_jpeg_mem_src:g' \
		-i src/libfreepv/JpegReader.cpp || die

	sed -e 's:^INSTALL(.*)::' \
		-i src/libfreepv/CMakeLists.txt || die
}

src_configure() {
	# bug 618856
	append-cxxflags -std=c++14

	cmake-utils_src_configure
}
