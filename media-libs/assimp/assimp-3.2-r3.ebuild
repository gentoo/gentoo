# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils versionator multilib

DESCRIPTION="Importer library to import assets from 3D files"
HOMEPAGE="https://github.com/assimp/assimp"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+boost samples static test tools"
SLOT="0"

RDEPEND="
	boost? ( dev-libs/boost )
	samples? ( x11-libs/libX11 virtual/opengl media-libs/freeglut )
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_prepare() {
	epatch "${FILESDIR}/test-cmakelists.patch"
	epatch "${FILESDIR}/findassimp.patch"
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build samples ASSIMP_SAMPLES) \
		$(cmake-utils_use_build tools ASSIMP_TOOLS) \
		$(cmake-utils_use_build static STATIC_LIB) \
		$(cmake-utils_use_enable !boost BOOST_WORKAROUND) \
		$(cmake-utils_use_build test TESTS)
		-DCMAKE_DEBUG_POSTFIX=""
		-DASSIMP_LIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)/"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	insinto /usr/share/cmake/Modules
	doins cmake-modules/Findassimp.cmake
}

src_test() {
	"${BUILD_DIR}/test/unit" || die
}
