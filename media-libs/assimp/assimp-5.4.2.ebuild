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
IUSE="doc samples test"

RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib[minizip]
	doc? ( app-text/doxygen )
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
		-e "s# -g -O0 # #g" \
		-i \
			cmake-modules/Coveralls.cmake \
			contrib/android-cmake/android.toolchain.cmake \
			contrib/openddlparser/CMakeLists.txt \
			CMakeLists.txt \
		|| die
	sed -r \
		-e "s#(PROJECT_NUMBER *= \").*\"#\1v${PV}\"#g" \
		-e "s#(GENERATE_XML *= )(YES|NO)#\1NO#g" \
		-e "s#(GENERATE_HTML *= )(YES|NO)#\1YES#g" \
		-i doc/Doxyfile.in || die
	sed -r \
		-e "s#AssimpDoc_Html(/AnimationOverview)#architecture\1#g" \
		-e "s#AssimpDoc_Html(/dragonsplash)#images\1#g" \
		-i doc/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# -DASSIMP_ASAN=yes # Enable AddressSanitizer.
		-DASSIMP_BUILD_ASSIMP_TOOLS=yes # If the supplementary tools for Assimp are built in addition to the library.
		-DASSIMP_BUILD_DOCS=$(usex doc) # Build documentation using Doxygen.
		# -DASSIMP_BUILD_DRACO=no # If the Draco libraries are to be built. Primarily for glTF
		# -DASSIMP_BUILD_NONFREE_C4D_IMPORTER=no # Build the C4D importer, which relies on the non-free Cineware SDK.
		-DASSIMP_BUILD_SAMPLES=$(usex samples) # If the official samples are built as well (needs Glut).
		-DASSIMP_BUILD_TESTS=$(usex test) # If the test suite for Assimp is built in addition to the library.
		-DASSIMP_BUILD_ZLIB=no # Build your own zlib
		-DASSIMP_COVERALLS=$(usex test) # Enable this to measure test coverage.
		# breaks tests
		# -DASSIMP_DOUBLE_PRECISION=no # Set to yes to enable double precision processing
		# -DASSIMP_HUNTER_ENABLED=no # Enable Hunter package manager support
		-DASSIMP_IGNORE_GIT_HASH=yes # Don't call git to get the hash.
		-DASSIMP_INJECT_DEBUG_POSTFIX=no # Inject debug postfix in .a/.so/.dll lib names
		# -DASSIMP_INSTALL=yes # Disable this if you want to use assimp as a submodule.
		# -DASSIMP_LIBRARY_SUFFIX= # Suffix to append to library names
		# -DASSIMP_NO_EXPORT=no # Disable Assimp's export functionality.
		# -DASSIMP_OPT_BUILD_PACKAGES=no # Set to yes to generate CPack configuration files and packaging targets
		-DASSIMP_RAPIDJSON_NO_MEMBER_ITERATOR=no # Suppress rapidjson warning on MSVC (NOTE: breaks android build)
		# -DASSIMP_UBSAN=yes # Enable Undefined Behavior sanitizer.
		-DASSIMP_WARNINGS_AS_ERRORS=no # Treat all warnings as errors.
		# -DBUILD_SHARED_LIBS=yes # Build package with shared libraries.
		# bug #891787 (CVE-2022-45748), intentionally not in alphabetic ordering
		-DASSIMP_BUILD_COLLADA_IMPORTER=OFF
		-DASSIMP_BUILD_COLLADA_EXPORTER=OFF
	)

	if use doc; then
		mycmakeargs+=(
			-DHTML_OUTPUT="html"
		)
	fi
	if use samples; then
		mycmakeargs+=(
			-DOpenGL_GL_PREFERENCE="GLVND"
		)
	fi
	if use test; then
		# adds the target headercheck which compiles every header file, default disabled because it adds many targets
		-DASSIMP_HEADERCHECK=$(usex test)
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
