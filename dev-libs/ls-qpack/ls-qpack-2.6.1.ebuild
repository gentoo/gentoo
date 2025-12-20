# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="QPACK compression library for use with HTTP/3"
HOMEPAGE="https://github.com/litespeedtech/ls-qpack/"
SRC_URI="
	https://github.com/litespeedtech/ls-qpack/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0/2"
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/xxhash:=
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
	# https://github.com/litespeedtech/ls-qpack/pull/78
	# https://github.com/litespeedtech/ls-qpack/pull/79
	"${FILESDIR}/${P}-test.patch"
)

src_configure() {
	local mycmakeargs=(
		# no support for shared + static both
		-DBUILD_SHARED_LIBS=ON
		# these are only test helpers
		-DLSQPACK_BIN=OFF
		-DLSQPACK_TESTS=$(usex test)
		# use system xxhash
		-DLSQPACK_XXH=OFF
	)
	cmake_src_configure
}
