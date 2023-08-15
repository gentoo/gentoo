# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fast JSON library in C"
HOMEPAGE="https://github.com/ibireme/yyjson https://ibireme.github.io/yyjson/doc/doxygen/html/"
SRC_URI="https://github.com/ibireme/yyjson/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT test? ( BSD )"
SLOT="0"
KEYWORDS="~amd64"

IUSE="doc test"

RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.0-disable-werror.patch
	"${FILESDIR}"/${PN}-0.7.0-fix-clang-16-valgrind.patch
)

src_configure() {
	local mycmakeargs=(
		-DYYJSON_BUILD_DOC=$(usex doc)
		-DYYJSON_BUILD_TESTS=$(usex test)
		-DYYJSON_ENABLE_VALGRIND=$(usex test)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	use doc && dodoc -r "${BUILD_DIR}"/doxygen/html
}
