# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

CommitId=7d2a4e9931a82adc3814275b6219a03e24e36b4c

DESCRIPTION="Quantized Neural Networks PACKage"
HOMEPAGE="https://github.com/pytorch/QNNPACK/"
SRC_URI="https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs test"

RDEPEND="
	dev-libs/cpuinfo
	dev-libs/pthreadpool
"
DEPEND="${RDEPEND}
	dev-libs/FP16
	dev-libs/FXdiv
"

BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( static-libs )"

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_configure() {
	local mycmakeargs=(
		-DQNNPACK_BUILD_BENCHMARKS=OFF
		-DQNNPACK_BUILD_TESTS=$(usex test ON OFF)
		-DQNNPACK_LIBRARY_TYPE=$(usex static-libs static shared)
	)

	cmake_src_configure
}
