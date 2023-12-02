# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Importer library to import assets from 3D files"
HOMEPAGE="https://github.com/assimp/assimp"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/5.2.5"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"
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

PATCHES=(
	"${FILESDIR}"/${PN}-5.2.5-fix-version.patch
	"${FILESDIR}"/${PN}-5.2.5-disable-failing-tests.patch
	"${FILESDIR}"/${PN}-5.2.5-disable-collada-tests.patch
)

DOCS=( CodeConventions.md Readme.md )

src_prepare() {
	if use x86 ; then
		eapply "${FILESDIR}"/${PN}-5.2.5-drop-failing-tests-for-abi_x86_32.patch
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DASSIMP_ASAN=OFF
		-DASSIMP_BUILD_ASSIMP_TOOLS=ON
		-DASSIMP_BUILD_DOCS=OFF
		-DASSIMP_BUILD_SAMPLES=$(usex samples)
		-DASSIMP_BUILD_TESTS=$(usex test)
		-DASSIMP_BUILD_ZLIB=OFF
		-DASSIMP_DOUBLE_PRECISION=OFF
		-DASSIMP_INJECT_DEBUG_POSTFIX=OFF
		-DASSIMP_IGNORE_GIT_HASH=ON
		-DASSIMP_UBSAN=OFF
		-DASSIMP_WARNINGS_AS_ERRORS=OFF
		# bug #891787, intentionally not in alphabetic ordering
		-DASSIMP_BUILD_COLLADA_IMPORTER=OFF
		-DASSIMP_BUILD_COLLADA_EXPORTER=OFF
	)

	if use samples; then
		mycmakeargs+=( -DOpenGL_GL_PREFERENCE="GLVND" )
	fi

	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}/bin/unit" || die
}
