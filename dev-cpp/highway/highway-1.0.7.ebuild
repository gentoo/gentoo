# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Performance-portable, length-agnostic SIMD with runtime dispatch"
HOMEPAGE="https://github.com/google/highway"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/highway.git"
else
	SRC_URI="https://github.com/google/highway/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="cpu_flags_arm_neon test"

DEPEND="test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )"

RESTRICT="!test? ( test )"

multilib_src_configure() {
	local mycmakeargs=(
		-DHWY_CMAKE_ARM7=$(usex cpu_flags_arm_neon)
		-DBUILD_TESTING=$(usex test)
		-DHWY_WARNINGS_ARE_ERRORS=OFF
	)

	use test && mycmakeargs+=( "-DHWY_SYSTEM_GTEST=ON" )

	cmake_src_configure
}
