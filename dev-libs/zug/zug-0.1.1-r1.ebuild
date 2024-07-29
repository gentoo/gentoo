# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Transducers for C++"
HOMEPAGE="https://sinusoid.es/zug/"
SRC_URI="https://github.com/arximboldi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/boost:="

BDEPEND="
	test? ( <dev-cpp/catch-3:0 )
"

src_configure() {
	local mycmakeargs=(
		-DCCACHE=no
		-DDISABLE_WERROR=yes
		-Dzug_BUILD_DOCS=no # Recheck if documentation is in a better state when bumping
		-Dzug_BUILD_EXAMPLES=no
		-Dzug_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use test; then
		cmake_build tests
	fi

}
