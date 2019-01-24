# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION="Unit testing framework for C"
HOMEPAGE="https://cmocka.org/"
SRC_URI="https://cmocka.org/files/1.1/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs test"

BDEPEND="
	doc? ( app-doc/doxygen[dot] )
"

DOCS=( AUTHORS ChangeLog README.md )

PATCHES=(
	"${FILESDIR}/${P}-fix-doxygen.patch" # bug 671404
	"${FILESDIR}/${P}-examples.patch"
)

multilib_src_configure() {
	local mycmakeargs=(
		-DWITH_EXAMPLES=$(usex examples)
		-DWITH_STATIC_LIB=$(usex static-libs)
		-DUNIT_TESTING=$(usex test)
		$(multilib_is_native_abi && cmake-utils_use_find_package doc Doxygen \
			|| echo -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON)
	)

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
	multilib_is_native_abi && use doc && cmake-utils_src_compile docs
}

multilib_src_install() {
	if multilib_is_native_abi && use doc; then
		local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	fi

	cmake-utils_src_install
}
