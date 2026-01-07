# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Library for reading and editing audio meta data"
HOMEPAGE="https://taglib.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MPL-1.1"
SLOT="0/2"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="doc examples test"

RESTRICT="!test? ( test )"

RDEPEND="virtual/zlib:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	dev-libs/utfcpp
	test? ( dev-util/cppunit[${MULTILIB_USEDEP}] )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )
"

# https://github.com/taglib/taglib/pull/1285
PATCHES=( "${FILESDIR}"/${P}-cmake-minreqver-3.10.patch ) # bug #964576

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

	if multilib_is_native_abi && use doc; then
		cmake_build docs
	fi
}

multilib_src_test() {
	eninja -C "${BUILD_DIR}" check
}

multilib_src_install() {
	if multilib_is_native_abi && use doc; then
		HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	fi
	cmake_src_install
}
