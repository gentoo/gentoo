# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

CommitId=b40bae27785787b6dd70788986fd96434cf90ae2

DESCRIPTION="CPU INFOrmation library"
HOMEPAGE="https://github.com/pytorch/cpuinfo/"
SRC_URI="https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
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
	local mycmakeargs=(
		-DCPUINFO_BUILD_BENCHMARKS=OFF
		-DCPUINFO_BUILD_UNIT_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}
