# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

CommitId=4ec760a3d1f69e32ba460ecd2513f29b8428700b
DESCRIPTION="Machine code generation for C++"
HOMEPAGE="https://asmjit.com/"
SRC_URI="https://github.com/asmjit/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_configure() {
	local mycmakeargs=(
		-DASMJIT_TEST=$(usex test TRUE FALSE)
	)
	cmake_src_configure
}
