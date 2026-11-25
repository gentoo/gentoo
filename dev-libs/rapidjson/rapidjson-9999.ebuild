# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A fast JSON parser/generator for C++ with both SAX/DOM style API"
HOMEPAGE="https://rapidjson.org/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/Tencent/rapidjson.git"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	# no up-to-date releases or tags
	COMMIT="24b5e7a8b27f42fa16b96fc70aade9106cf7102f"
	SRC_URI="https://github.com/Tencent/rapidjson/archive/${COMMIT}.tar.gz -> rapidjson-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
	S="${WORKDIR}/rapidjson-${COMMIT}"
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
	"${FILESDIR}/${PN}-1.1.0-system_gtest.patch"
	"${FILESDIR}/${PN}-1.1.1-cmake4.patch"
)

src_prepare() {
	cmake_src_prepare

	sed -i -e 's| -march=native||g' CMakeLists.txt || die
	sed -i -e 's| -mcpu=native||g' CMakeLists.txt || die
	sed -i -e 's| -Werror||g' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DDOC_INSTALL_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DRAPIDJSON_BUILD_CXX11=OFF # latest gtest requires C++14 or later
		-DRAPIDJSON_BUILD_CXX17=ON
		-DRAPIDJSON_BUILD_DOC=$(usex doc)
		-DRAPIDJSON_BUILD_EXAMPLES=$(usex examples)
		-DRAPIDJSON_BUILD_TESTS=$(usex test)
		-DRAPIDJSON_BUILD_THIRDPARTY_GTEST=OFF
	)
	use test && mycmakeargs+=(
		-DVALGRIND_FOUND=
	)
	cmake_src_configure
}
