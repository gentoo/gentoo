# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="Unit testing framework for C"
HOMEPAGE="https://cmocka.org/"
SRC_URI="https://cmocka.org/files/$(ver_cut 1-2)/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-text/doxygen[dot] )"

multilib_src_configure() {
	append-lfs-flags

	local mycmakeargs=(
		-DWITH_EXAMPLES=$(usex examples)
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
