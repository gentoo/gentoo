# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

CommitId=98b0a46bce017382a6351a19577ec43a715b6835

DESCRIPTION="conversion to/from half-precision floating point formats"
HOMEPAGE="https://github.com/Maratyszcza/FP16/"
SRC_URI="https://github.com/Maratyszcza/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"

BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-setfill.patch
)

src_prepare() {
	sed -i -e "s|CXX_STANDARD 11|CXX_STANDARD 14|" CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DFP16_BUILD_BENCHMARKS=OFF
		-DFP16_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}
