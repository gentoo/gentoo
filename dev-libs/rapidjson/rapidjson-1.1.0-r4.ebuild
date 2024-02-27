# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A fast JSON parser/generator for C++ with both SAX/DOM style API"
HOMEPAGE="https://rapidjson.org/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/miloyip/rapidjson.git"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	SRC_URI="https://github.com/miloyip/rapidjson/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv sparc x86"
	S="${WORKDIR}/rapidjson-${PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? ( app-text/doxygen )
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/${P}-gcc-7.patch"
	"${FILESDIR}/${P}-system_gtest.patch"
	"${FILESDIR}/${P}-valgrind_optional.patch"
	"${FILESDIR}/${P}-gcc14-const.patch"
)

src_prepare() {
	cmake_src_prepare

	sed -i -e 's| -march=native||g' CMakeLists.txt || die
	sed -i -e 's| -Werror||g' CMakeLists.txt example/CMakeLists.txt test/unittest/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DDOC_INSTALL_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DRAPIDJSON_BUILD_CXX11=OFF # latest gtest requires C++14 or later
		-DRAPIDJSON_BUILD_DOC=$(usex doc)
		-DRAPIDJSON_BUILD_EXAMPLES=$(usex examples)
		-DRAPIDJSON_BUILD_TESTS=$(usex test)
		-DRAPIDJSON_BUILD_THIRDPARTY_GTEST=OFF
	)
	use test && mycmakeargs+=(
		-DVALGRIND_EXECUTABLE=
	)
	cmake_src_configure
}
