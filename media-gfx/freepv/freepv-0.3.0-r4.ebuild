# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils eutils

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
	virtual/jpeg
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXxf86vm"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc44.patch \
		"${FILESDIR}"/${P}-gcc46.patch \
		"${FILESDIR}"/${P}-noplugin.patch \
		"${FILESDIR}"/${P}-libpng14.patch \
		"${FILESDIR}"/${P}-stringh.patch

	sed -i \
		-e 's:jpeg_mem_src:freepv_jpeg_mem_src:g' \
		src/libfreepv/JpegReader.cpp || die 'jpeg sed failed'

	sed -i -e 's:^INSTALL(.*)::' \
		src/libfreepv/CMakeLists.txt || die 'static lib install sed failed'
}
