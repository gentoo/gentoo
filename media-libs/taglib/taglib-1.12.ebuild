# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION="Library for reading and editing audio meta data"
HOMEPAGE="https://taglib.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MPL-1.1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
SLOT="0"
IUSE="debug doc examples test"

RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
"
RDEPEND="
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( >=dev-util/cppunit-1.13.2[${MULTILIB_USEDEP}] )
"

PATCHES=( "${FILESDIR}"/${P}-cmake.patch ) # PR#996

MULTILIB_CHOST_TOOLS=(
	/usr/bin/taglib-config
)

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(multilib_native_usex examples)
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile

	if multilib_is_native_abi; then
		use doc && cmake_build docs
	fi
}

multilib_src_test() {
	eninja check
}

multilib_src_install() {
	cmake_src_install

	if multilib_is_native_abi && use doc; then
		HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	fi
}
