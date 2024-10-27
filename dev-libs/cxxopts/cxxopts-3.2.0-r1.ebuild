# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Lightweight C++ command line option parser"
HOMEPAGE="https://github.com/jarro2783/cxxopts"
SRC_URI="https://github.com/jarro2783/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv x86"
IUSE="icu test"

RESTRICT="
	!test? ( test )
"

DOCS=(
	README.md
	CHANGELOG.md
)

src_prepare() {
	sed -r -e 's:-Werror[[:space:]]*::' -i cmake/cxxopts.cmake || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCXXOPTS_BUILD_EXAMPLES:BOOL=OFF
		-DCXXOPTS_BUILD_TESTS:BOOL=$(usex test)
		-DCXXOPTS_ENABLE_INSTALL:BOOL=ON
		-DCXXOPTS_USE_UNICODE_HELP:BOOL=$(usex icu)
	)
	cmake_src_configure
}
