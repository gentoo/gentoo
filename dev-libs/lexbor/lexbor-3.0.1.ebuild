# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Modular web engine (HTML/CSS parser, renderer, ...)"
HOMEPAGE="https://lexbor.com/ https://github.com/lexbor/lexbor"
SRC_URI="https://github.com/lexbor/lexbor/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV/.*}"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"

src_prepare() {
	cmake_src_prepare

	sed -i 's;${LEXBOR_OPTIMIZATION_LEVEL};;' CMakeLists.txt || die
}

src_configure() {
	# -DLEXBOR_BUILD_UTILS seems to be just internal utilities, doesn't affects installed files
	local mycmakeargs=(
		-DLEXBOR_BUILD_STATIC=OFF # static-libs
		-DLEXBOR_BUILD_TESTS=$(usex test)
		-DLEXBOR_BUILD_TESTS_CPP=$(usex test)
		-DLEXBOR_BUILD_EXAMPLES=$(usex test) # extra tests, doesn't affects installed files
		-DLEXBOR_BUILD_WASM=OFF # requires emscripten
	)

	cmake_src_configure
}
