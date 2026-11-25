# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Open h.265 video codec implementation"
HOMEPAGE="https://github.com/strukturag/libde265"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/strukturag/libde265.git"
	inherit git-r3
else
	SRC_URI="https://github.com/strukturag/libde265/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86"
fi

LICENSE="LGPL-3 tools? ( MIT )"
SLOT="0"
IUSE="dec265 debug sdl tools"
IUSE+=" cpu_flags_x86_avx2 cpu_flags_x86_avx512f cpu_flags_x86_sse cpu_flags_arm_neon"

RDEPEND="
	dec265? (
		sdl? ( media-libs/libsdl2 )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="dec265? ( virtual/pkgconfig )"

multilib_src_configure() {
	local mycmakeargs=(
		-DDE265_LOG_LEVEL=$(usex debug debug error)

		-DENABLE_AVX2=$(usex cpu_flags_x86_avx2)
		-DENABLE_AVX512=$(usex cpu_flags_x86_avx512f)

		-DENABLE_DECODER=$(multilib_native_usex dec265)

		-DENABLE_SDL=$(usex sdl)

		# dev-tools dir isn't in release tarballs
		# https://github.com/strukturag/libde265/issues/545
		#-DENABLE_INTERNAL_DEVELOPMENT_TOOLS=$(usex test)

		# Require libvideogfx or libswscale
		-DENABLE_SHERLOCK265=OFF
	)

	if use cpu_flags_x86_sse || use cpu_flags_arm_neon || use arm64 ; then
		mycmakeargs+=( -DENABLE_SIMD=ON )
	else
		mycmakeargs+=( -DENABLE_SIMD=OFF )
	fi

	cmake_src_configure
}
