# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

CommitId=63058eff77e11aa15bf531df5dd34395ec3017c8
DESCRIPTION="Division via fixed-point multiplication by inverse"
HOMEPAGE="https://github.com/Maratyszcza/FXdiv/"
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
)

src_prepare() {
	cmake_src_prepare

	# >=dev-cpp/gtest-1.13.0 requires C++14 standard or later
	sed -i -e 's/CXX_STANDARD 11/CXX_STANDARD 14/g' \
		CMakeLists.txt || die "sed failed"
}

src_configure() {
	local mycmakeargs=(
		-DFXDIV_BUILD_BENCHMARKS=OFF
		-DFXDIV_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}
