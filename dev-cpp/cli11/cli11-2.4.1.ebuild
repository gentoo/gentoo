# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Command line parser for C++11"
HOMEPAGE="https://cliutils.github.io/CLI11/book/"
SRC_URI="
	https://github.com/CLIUtils/CLI11/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"
S=${WORKDIR}/${PN^^}-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-cpp/catch:0
		dev-libs/boost
	)
"
BDEPEND="
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
"

src_configure() {
	local mycmakeargs=(
		-DCLI11_BUILD_DOCS=$(usex doc)
		-DCLI11_BUILD_EXAMPLES=no
		-DCLI11_BUILD_TESTS=$(usex test)
		$(usev test -DCLI11_BOOST=yes)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile all $(usev doc docs)
}

src_install() {
	local DOCS=( CHANGELOG.md README.md book/{chapters,code,*.md} )
	cmake_src_install

	use doc && dodoc -r "${BUILD_DIR}"/docs/html
}
