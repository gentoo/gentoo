# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fast JSON library in C"
HOMEPAGE="https://github.com/ibireme/yyjson https://ibireme.github.io/yyjson/doc/doxygen/html/"
SRC_URI="https://github.com/ibireme/yyjson/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT test? ( BSD )"
SLOT="0/0"
KEYWORDS="~amd64 ~arm arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="doc test"

RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.0-disable-werror.patch
)

src_configure() {
	local mycmakeargs=(
		-DYYJSON_BUILD_DOC=$(usex doc)
		-DYYJSON_BUILD_TESTS=$(usex test)
		-DYYJSON_ENABLE_VALGRIND=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	use doc && dodoc -r "${BUILD_DIR}"/doxygen/html
}
