# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

CommitId=6481e8bef08f606ddd627e4d3be89f64d62e1b8a

DESCRIPTION="CPU INFOrmation library"
HOMEPAGE="https://github.com/pytorch/cpuinfo/"
SRC_URI="https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=(
	"${FILESDIR}"/${PN}-2022.03.26-gentoo.patch
	"${FILESDIR}"/${P}-test.patch
)

src_prepare() {
	cmake_src_prepare

	# >=dev-cpp/gtest-1.13.0 depends on building with at least C++14 standard
	sed -i -e 's/CXX_STANDARD 11/CXX_STANDARD 14/' \
		CMakeLists.txt || die "sed failed"
}

src_configure() {
	local mycmakeargs=(
		-DCPUINFO_BUILD_BENCHMARKS=OFF
		-DCPUINFO_BUILD_UNIT_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}
