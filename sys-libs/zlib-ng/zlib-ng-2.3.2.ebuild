# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Worth keeping an eye on 'develop' branch upstream for possible backports,
# as they copied this practice from sys-libs/zlib upstream.

inherit cmake-multilib multibuild

DESCRIPTION="Fork of the zlib data compression library"
HOMEPAGE="https://github.com/zlib-ng/zlib-ng"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86"

CPU_USE=(
	x86_{avx2,avx512f,avx512_vnni,sse2,ssse3,sse4_1,sse4_2,pclmul,vpclmulqdq}
	arm_{crc32,neon}
	ppc_{altivec,vsx2,vsx3}
)
IUSE="compat ${CPU_USE[@]/#/cpu_flags_} static-libs test"

RESTRICT="!test? ( test )"

DEPEND="
	test? ( dev-cpp/gtest )
"
RDEPEND="
	compat? ( !sys-libs/zlib )
"

run_both() {
	local MULTIBUILD_VARIANTS=( base )
	use compat && MULTIBUILD_VARIANTS+=( compat )

	multibuild_foreach_variant "${@}"
}

my_src_configure() {
	local compat=OFF
	[[ ${MULTIBUILD_VARIANT} == compat ]] && compat=ON
	local mycmakeargs=(
		"${mycmakeargs[@]}"
		-DZLIB_COMPAT="${compat}"
	)

	cmake_src_configure
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DWITH_BENCHMARKS=OFF
		-DWITH_BENCHMARK_APPS=OFF
		-DWITH_FUZZERS=OFF
		-DWITH_GTEST=$(usex test)
	)
	if use static-libs; then
		mycmakeargs+=(
			# upstream build system builds both if BUILD_SHARED_LIBS is unset
			-UBUILD_SHARED_LIBS
		)
	fi

	# The intrinsics options are all defined conditionally, so we need
	# to enable them on/off per-arch here for now.
	# TODO: There's no s390x USE_EXPAND yet
	if use amd64 || use x86 ; then
		mycmakeargs+=(
			-DWITH_AVX2=$(usex cpu_flags_x86_avx2)
			-DWITH_AVX512=$(usex cpu_flags_x86_avx512f)
			-DWITH_AVX512VNNI=$(usex cpu_flags_x86_avx512_vnni)
			-DWITH_SSE2=$(usex cpu_flags_x86_sse2)
			-DWITH_SSSE3=$(usex cpu_flags_x86_ssse3)
			-DWITH_SSE41=$(usex cpu_flags_x86_sse4_1)
			-DWITH_SSE42=$(usex cpu_flags_x86_sse4_2)
			-DWITH_PCLMULQDQ=$(usex cpu_flags_x86_pclmul)
			-DWITH_VPCLMULQDQ=$(usex cpu_flags_x86_vpclmulqdq)
		)
	fi

	if use arm || use arm64 ; then
		mycmakeargs+=(
			-DWITH_ARMV8=$(usex cpu_flags_arm_crc32)
			-DWITH_NEON=$(usex cpu_flags_arm_neon)
		)
	fi

	if use ppc || use ppc64 ; then
		# The POWER8 support is VSX which was introduced
		# VSX2 was introduced with POWER8, so use that as a proxy for it
		mycmakeargs+=(
			-DWITH_ALTIVEC=$(usex cpu_flags_ppc_altivec)
			-DWITH_POWER8=$(usex cpu_flags_ppc_vsx2)
			-DWITH_POWER9=$(usex cpu_flags_ppc_vsx3)
		)
	fi

	run_both my_src_configure
}

multilib_src_compile() { run_both cmake_src_compile; }
multilib_src_test() { run_both cmake_src_test; }
multilib_src_install() { run_both cmake_src_install; }

pkg_postinst() {
	if use compat ; then
		ewarn "zlib-ng is experimental and replacing the system zlib is dangerous"
		ewarn "Please be careful!"
		ewarn
		ewarn "The following link explains the guarantees (and what is NOT guaranteed):"
		ewarn "https://github.com/zlib-ng/zlib-ng/blob/2.0.x/PORTING.md"
	fi
}
