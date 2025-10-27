# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="Performance-portable, length-agnostic SIMD with runtime dispatch"
HOMEPAGE="https://github.com/google/highway"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/highway.git"
else
	SRC_URI="https://github.com/google/highway/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"

IUSE="test"

declare -A CPU_FEATURES=(
	[NEON]="arm"
	[SSE2]="x86"
	# [LASX]="loong"
	# [LSX]="loong"
)
add_cpu_features_use() {
	for flag in "${!CPU_FEATURES[@]}"; do
		IFS=$';' read -r arch use <<< "${CPU_FEATURES[${flag}]}"
		IUSE+=" cpu_flags_${arch}_${use:-${flag,,}}"
	done
}
add_cpu_features_use

DEPEND="test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )"

RESTRICT="!test? ( test )"

multilib_src_configure() {
	# 938175
	# highway builds runtime dispatched code
	filter-flags -m*

	local mycmakeargs=(
		# ARM7 is 32bit only
		-DHWY_CMAKE_ARM7="$(usex arm "$(usex cpu_flags_arm_neon)")"
		# -DHWY_CMAKE_LASX="$(usex cpu_flags_loong_lasx)"
		# -DHWY_CMAKE_LSX="$(usex cpu_flags_loong_lsx)"
		-DHWY_CMAKE_RVV="$(usex riscv)"
		-DHWY_CMAKE_SSE2="$(usex cpu_flags_x86_sse2)"
		-DBUILD_TESTING=$(usex test)
		-DHWY_ENABLE_TESTS=$(usex test)
		-DHWY_WARNINGS_ARE_ERRORS=OFF
	)

	if use test; then
		mycmakeargs+=(
			-DHWY_SYSTEM_GTEST=ON
			-DHWY_TEST_STANDALONE=OFF
		)
	fi

	cmake_src_configure
}
