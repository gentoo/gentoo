# Copyright 2002-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_P=xdelta3-${PV}
DESCRIPTION="Computes changes between binary or text files and creates deltas"
HOMEPAGE="https://github.com/jmacd/xdelta/"
SRC_URI="https://github.com/jmacd/xdelta/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}/xdelta3"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="examples lzma test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/blake3:=
	lzma? ( app-arch/xz-utils:= )
"
RDEPEND="
	${DEPEND}
"

src_configure() {
	local mycmakeargs=(
		-DXD3_BUILD_TESTS=$(usex test)
		-DXD3_SECONDARY_FGK=OFF
		# link dynamically to liblzma
		-DXD3_LIB_LZMA=ON
		-DXD3_LZMA_MODE=$(usex lzma on off)
		-DXD3_LARGESIZET=ON
		-DXD3_ARMOR=ON
		# TODO: for now we're getting away with a CMake warning
		# and implicit linking to -lblake3
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc draft-korn-vcdiff.txt
	use examples && dodoc -r examples
}
