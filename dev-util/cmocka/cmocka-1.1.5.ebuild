# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="Unit testing framework for C"
HOMEPAGE="https://cmocka.org/"
SRC_URI="https://cmocka.org/files/1.1/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? ( app-doc/doxygen[dot] )
"

multilib_src_configure() {
	local mycmakeargs=(
		-DWITH_EXAMPLES=$(usex examples)
		-DWITH_STATIC_LIB=$(usex static-libs)
		-DUNIT_TESTING=$(usex test)
		$(multilib_is_native_abi && cmake_use_find_package doc Doxygen \
			|| echo -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON)
	)

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
	multilib_is_native_abi && use doc && cmake_src_compile docs
}

multilib_src_install() {
	if multilib_is_native_abi && use doc; then
		local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	fi

	cmake_src_install
}
