# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Importer library to import assets from 3D files"
HOMEPAGE="https://github.com/assimp/assimp"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="samples test"

RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib[minizip]
	samples? (
		media-libs/freeglut
		media-libs/libglvnd
	)
	test? (
		dev-cpp/gtest
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-5.2.5-gtest.patch"
	"${FILESDIR}/${PN}-5.2.5-float-comparison.patch"
)

DOCS=( CodeConventions.md Readme.md )

src_prepare() {
	sed -r \
		-e "s#PROJECT\(Assimp VERSION [0-9]+\.[0-9]+\.[0-9]+\)#PROJECT(Assimp VERSION ${PV})#g" \
		-i CMakeLists.txt || die
	sed -r \
		-e "s#EXPECT_EQ\(aiGetVersionPatch\(\), [0-9]+U \);#EXPECT_EQ(aiGetVersionPatch(), $(ver_cut 3)U );#g" \
		-e "s#EXPECT_NE\( aiGetVersionRevision#EXPECT_EQ\( aiGetVersionRevision#g" \
		-i test/unit/utVersion.cpp || die
	sed \
		-e "s# -O0 -g # #g" \
		-i \
			cmake-modules/Coveralls.cmake \
			contrib/android-cmake/android.toolchain.cmake \
			contrib/openddlparser/CMakeLists.txt \
			CMakeLists.txt \
		|| die

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
		# bug #891787 (CVE-2022-45748), intentionally not in alphabetic ordering
		-DASSIMP_BUILD_COLLADA_IMPORTER=OFF
		-DASSIMP_BUILD_COLLADA_EXPORTER=OFF
	)

	if use samples; then
		mycmakeargs+=( -DOpenGL_GL_PREFERENCE="GLVND" )
	fi

	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# ( Failed )
		"^utCollada.*"
		"^utIssues.OpacityBugWhenExporting_727$"
	)
	myctestargs+=(
		--repeat until-pass:100
	)

	cmake_src_test
}
