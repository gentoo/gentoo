# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library of persistent and immutable data structures written in C++"
HOMEPAGE="https://sinusoid.es/immer/"
SRC_URI="https://github.com/arximboldi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=
	dev-libs/boehm-gc
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? ( <dev-cpp/catch-3:0 )
"

PATCHES=(
	"${FILESDIR}"/${P}-fix-dvector-test.patch
)

src_configure() {
	local mycmakeargs=(
		-DCCACHE=no
		-Dimmer_BUILD_DOCS=OFF # Recheck if documentation is in a better state when bumping
		-Dimmer_BUILD_EXAMPLES=OFF
		-Dimmer_BUILD_EXTRAS=OFF
		-Dimmer_BUILD_TESTS=$(usex test)
		-DDISABLE_WERROR=ON
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use test; then
		cmake_build tests
	fi
}
