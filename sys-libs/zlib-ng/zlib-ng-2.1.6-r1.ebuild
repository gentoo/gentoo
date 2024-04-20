# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Worth keeping an eye on 'develop' branch upstream for possible backports,
# as they copied this practice from sys-libs/zlib upstream.

inherit cmake-multilib

DESCRIPTION="Fork of the zlib data compression library"
HOMEPAGE="https://github.com/zlib-ng/zlib-ng"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~sparc ~x86"

CPU_USE=(
	x86_{avx2,avx512f,avx512_vnni,sse2,ssse3,sse4_2,pclmul,vpclmulqdq}
	arm_{crc32,neon}
	ppc_{altivec,vsx2,vsx3}
)
IUSE="compat ${CPU_USE[@]/#/cpu_flags_} test"

RESTRICT="!test? ( test )"

DEPEND="
	test? ( dev-cpp/gtest )
"
RDEPEND="
	compat? ( !sys-libs/zlib )
"

multilib_src_configure() {
	local mycmakeargs=(
		-DZLIB_COMPAT=$(usex compat)
		-DZLIB_ENABLE_TESTS=$(usex test)
		-DWITH_GTEST=$(usex test)

		# Unaligned access is controversial and undefined behaviour
		# Let's keep it off for now
		# https://github.com/gentoo/gentoo/pull/17167
		-DWITH_UNALIGNED=OFF
	)

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
			-DWITH_SSE42=$(usex cpu_flags_x86_sse4_2)
			-DWITH_PCLMULQDQ=$(usex cpu_flags_x86_pclmul)
			-DWITH_VPCLMULQDQ=$(usex cpu_flags_x86_vpclmulqdq)
		)
	fi

	if use arm || use arm64 ; then
		mycmakeargs+=(
			-DWITH_ACLE=$(usex cpu_flags_arm_crc32)
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

	cmake_src_configure
}

pkg_postinst() {
	if use compat ; then
		ewarn "zlib-ng is experimental and replacing the system zlib is dangerous"
		ewarn "Please be careful!"
		ewarn
		ewarn "The following link explains the guarantees (and what is NOT guaranteed):"
		ewarn "https://github.com/zlib-ng/zlib-ng/blob/2.0.x/PORTING.md"
	fi
}
