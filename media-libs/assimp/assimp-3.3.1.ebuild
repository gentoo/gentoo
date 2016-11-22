# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils versionator multilib

DESCRIPTION="Importer library to import assets from 3D files"
HOMEPAGE="https://github.com/assimp/assimp"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="samples static test tools"
SLOT="0"

RDEPEND="
	dev-libs/boost
	samples? ( x11-libs/libX11 virtual/opengl media-libs/freeglut )
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_prepare() {
	eapply "${FILESDIR}/findassimp-${PV}.patch"
	eapply_user
}

src_configure() {
	mycmakeargs=(
		-DASSIMP_BUILD_SAMPLES=$(usex samples) \
		-DASSIMP_BUILD_ASSIMP_TOOLS=$(usex tools) \
		-DASSIMP_BUILD_STATIC_LIB=$(usex static) \
		-DASSIMP_BUILD_TESTS=$(usex test)
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
