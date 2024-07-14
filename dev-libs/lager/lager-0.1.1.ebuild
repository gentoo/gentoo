# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library to assist value-oriented design"
HOMEPAGE="https://sinusoid.es/lager/"
SRC_URI="https://github.com/arximboldi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=
	dev-libs/zug
	dev-libs/immer
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		<dev-cpp/catch-3:0
		dev-libs/cereal
	)
"

src_configure() {
	local mycmakeargs=(
		-DCCACHE=no
		-Dlager_BUILD_DEBUGGER_EXAMPLES=OFF
		-Dlager_BUILD_DOCS=OFF # Check if docs are more complete on version bumps
		-Dlager_BUILD_EXAMPLES=OFF
		-Dlager_BUILD_FAILURE_TESTS=OFF
		-Dlager_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use test; then
		cmake_build tests
	fi
}
