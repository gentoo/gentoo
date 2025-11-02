# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

CommitId=5e3d2445e6a84d9599bee2bf78edbb4d80865e1d

DESCRIPTION="CPU INFOrmation library"
HOMEPAGE="https://github.com/pytorch/cpuinfo/"
SRC_URI="https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-2023.11.04-gentoo.patch
	"${FILESDIR}"/${PN}-2023.01.13-test.patch
	"${FILESDIR}"/${PN}-2024.10.22.2-cmake.patch
)

src_configure() {
	local mycmakeargs=(
		-DCPUINFO_BUILD_BENCHMARKS=OFF
		-DCPUINFO_BUILD_UNIT_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}
