# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Importer library to import assets from 3D files"
HOMEPAGE="https://github.com/assimp/assimp"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="samples test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib[minizip]
	samples? (
		media-libs/freeglut
		virtual/opengl
		x11-libs/libX11
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.2.2-fix-usage-of-incompatible-minizip-data-structure.patch
	"${FILESDIR}"/${PN}-5.2.2-disable-failing-tests.patch
)

DOCS=( CodeConventions.md Readme.md )

src_configure() {
	local mycmakeargs=(
		-DASSIMP_ASAN=OFF
		-DASSIMP_BUILD_DOCS=OFF
		-DASSIMP_BUILD_SAMPLES=$(usex samples)
		-DASSIMP_BUILD_TESTS=$(usex test)
		-DASSIMP_ERROR_MAX=ON
		-DASSIMP_INJECT_DEBUG_POSTFIX=OFF
		-DASSIMP_IGNORE_GIT_HASH=ON
		-DASSIMP_UBSAN=OFF
	)

	if use samples; then
		mycmakeargs+=( -DOpenGL_GL_PREFERENCE="GLVND" )
	fi

	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}/bin/unit" || die
}
