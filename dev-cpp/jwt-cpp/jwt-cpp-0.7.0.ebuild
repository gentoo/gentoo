# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Thalhammer/jwt-cpp.git"
else
	SRC_URI="https://github.com/Thalhammer/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="header only library for creating and validating JSON Web Tokens in C++11"
HOMEPAGE="https://thalhammer.github.io/jwt-cpp/"

LICENSE="MIT"
SLOT="0"
IUSE="doc +picojson test"

DEPEND="
	dev-cpp/nlohmann_json
	dev-libs/openssl
	picojson? ( dev-cpp/picojson )
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? ( app-text/doxygen[dot] )
	test? ( dev-cpp/gtest )
"
RESTRICT="
	!picojson? ( test )
	!test? ( test )
"

DOCS=( README.md docs/{faqs,ssl,traits}.md )

src_prepare() {
	# Unbundle dev-cpp/nlohmann_json.
	rm -vrf include/nhlomann || die
	# Unbundle dev-cpp/picojson and fix include paths.
	# See also: https://github.com/Thalhammer/jwt-cpp/issues/213
	rm -vrf include/picojson || die
	find -name '*.h' -type f -print0 | xargs -0 sed -r -e "s:picojson/picojson\.h:picojson.h:g" -i || die
	# Prevent installation of bundled dev-cpp/picojson.
	sed -i -e 's:^\s*install.*picojson/picojson\.h.*$::' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
			-DJWT_DISABLE_PICOJSON="$(usex !picojson)"
			# Not useful for now, asks for non-existent CMake module.
			#-DJWT_EXTERNAL_PICOJSON="$(usex picojson)"
			# Examples are not installed and for development only.
			-DJWT_BUILD_EXAMPLES=NO
			-DJWT_BUILD_TESTS="$(usex test)"
			-DJWT_CMAKE_FILES_INSTALL_DIR="${EPREFIX}"/usr/share/cmake
			)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc; then
		doxygen || die
	fi
}

src_test() {
	"${BUILD_DIR}"/tests/jwt-cpp-test || die
}

src_install() {
	cmake_src_install
	use doc && local HTML_DOCS=(doxy/html/.)
	einstalldocs
}
