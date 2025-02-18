# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="The ANTLR 4 C++ Runtime"
HOMEPAGE="https://www.antlr.org/"
SRC_URI="https://www.antlr.org/download/antlr4-cpp-runtime-${PV}-source.zip"

LICENSE="BSD"
SLOT="4/${PV}"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"
BDEPEND="app-arch/unzip"

src_unpack() {
	mkdir "${S}" || die
	cd "${S}" || die
	unpack "antlr4-cpp-runtime-${PV}-source.zip"
}

src_prepare() {
	cmake_src_prepare

	sed -i -e "s|doc/libantlr$(ver_cut 1)|doc/${PF}|" CMakeLists.txt || die

	# Give proper gtest find_package name
	sed -i \
		-e 's/gtest_main/GTest::gtest_main/' \
		-e '/FetchContent_Declare/,/^$/ {
			/\sURL https:\/\/github.com\/google\/googletest/aFIND_PACKAGE_ARGS NAMES GTest
		}' runtime/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DANTLR_BUILD_CPP_TESTS=$(usex test)
		-DANTLR_BUILD_SHARED=ON
		-DANTLR_BUILD_STATIC=OFF
		-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
	)
	cmake_src_configure
}
