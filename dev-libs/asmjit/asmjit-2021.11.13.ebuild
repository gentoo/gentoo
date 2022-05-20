# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

CommitId=4ec760a3d1f69e32ba460ecd2513f29b8428700b
DESCRIPTION="Machine code generation for C++"
HOMEPAGE="https://asmjit.com/"
SRC_URI="https://github.com/asmjit/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_configure() {
	mycmakeargs=(
		-DASMJIT_TEST=$(usex test TRUE FALSE)
	)
	cmake_src_configure
}
