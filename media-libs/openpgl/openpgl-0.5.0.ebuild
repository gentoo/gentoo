# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Intel Open Path Guiding Library"
HOMEPAGE="https://github.com/OpenPathGuidingLibrary/openpgl"
SRC_URI="https://github.com/OpenPathGuidingLibrary/openpgl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

X86_CPU_FLAGS=( sse4_2 avx2 avx512dq )
CPU_FLAGS=( cpu_flags_arm_neon ${X86_CPU_FLAGS[@]/#/cpu_flags_x86_} )
IUSE="${CPU_FLAGS[@]} debug"
REQUIRED_USE="|| ( ${CPU_FLAGS[@]} )"

RDEPEND="
	media-libs/embree
	dev-cpp/tbb:=
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DOPENPGL_ISA_AVX2=$(usex cpu_flags_x86_avx2)
		-DOPENPGL_ISA_AVX512=$(usex cpu_flags_x86_avx512dq)
		-DOPENPGL_ISA_SSE4=$(usex cpu_flags_x86_sse4_2)
		# TODO look into neon 2x support
		-DOPENPGL_ISA_NEON=$(usex cpu_flags_arm_neon)
	)

	# This is currently needed on arm64 to get the NEON SIMD wrapper to compile the code successfully
	use cpu_flags_arm_neon && append-flags -flax-vector-conversions

	# Disable asserts
	append-cppflags $(usex debug '' '-DNDEBUG')

	cmake_src_configure
}
