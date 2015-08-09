# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils versionator

DESCRIPTION="Importer library to import assets from 3D files"
HOMEPAGE="http://assimp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+boost samples static tools"
SLOT="0"

DEPEND="
	boost? ( dev-libs/boost )
	samples? ( x11-libs/libX11 virtual/opengl media-libs/freeglut )
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/ASSIMP_LIB_INSTALL_DIR "lib"/ASSIMP_LIB_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR}/' CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build samples ASSIMP_SAMPLES) \
		$(cmake-utils_use_build tools ASSIMP_TOOLS) \
		$(cmake-utils_use_build static STATIC_LIB) \
		$(cmake-utils_use_enable !boost BOOST_WORKAROUND)
	)

	cmake-utils_src_configure
}
