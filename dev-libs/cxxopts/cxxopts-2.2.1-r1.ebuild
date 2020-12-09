# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Lightweight C++ command line option parser"
HOMEPAGE="https://github.com/jarro2783/cxxopts"
SRC_URI="https://github.com/jarro2783/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

DOCS=(
	README.md
	CHANGELOG.md
)

src_prepare() {
	sed -r -e 's:-Werror[[:space:]]*::' -i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local -a mycmakeopts=(
		-DCXXOPTS_BUILD_EXAMPLES=OFF
		-DCXXOPTS_BUILD_TESTS=$(usex test 'ON' 'OFF')
		-DCXXOPTS_ENABLE_INSTALL=ON
	)
	cmake_src_configure
}
