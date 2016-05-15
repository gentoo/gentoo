# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="OpenGL Mathematics"
HOMEPAGE="http://glm.g-truc.net/"
SRC_URI="https://github.com/g-truc/glm/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( HappyBunny MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_avx cpu_flags_x86_avx2"

RDEPEND="virtual/opengl"

src_configure() {
	if use test; then
		local mycmakeargs=( -DGLM_TEST_ENABLE=ON )

		use cpu_flags_x86_sse2 && mycmakeargs+=( -DGLM_TEST_ENABLE_SIMD_SSE2=ON )
		use cpu_flags_x86_sse3 && mycmakeargs+=( -DGLM_TEST_ENABLE_SIMD_SSE3=ON )
		use cpu_flags_x86_avx  && mycmakeargs+=( -DGLM_TEST_ENABLE_SIMD_AVX=ON )
		use cpu_flags_x86_avx2 && mycmakeargs+=( -DGLM_TEST_ENABLE_SIMD_AVX2=ON )
	fi

	cmake-utils_src_configure
}
