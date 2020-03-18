# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

DESCRIPTION="Importer library to import assets from 3D files"
HOMEPAGE="https://github.com/assimp/assimp"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="samples static test tools"
SLOT="0"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib:=[minizip]
	samples? (
		media-libs/freeglut
		virtual/opengl
		x11-libs/libX11
	)
	tools? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
		media-libs/devil
		virtual/opengl
	)
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/findassimp-3.3.1.patch"
	"${FILESDIR}/${P}-qt-5.11.0.patch"
	"${FILESDIR}/${P}-disabletest.patch" # bug 659122
)

src_configure() {
	append-flags -fno-strict-aliasing
	local mycmakeargs=(
		-DASSIMP_BUILD_SAMPLES=$(usex samples)
		-DASSIMP_BUILD_STATIC_LIB=$(usex static)
		-DASSIMP_BUILD_TESTS=$(usex test)
		-DASSIMP_BUILD_ASSIMP_TOOLS=$(usex tools)
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
