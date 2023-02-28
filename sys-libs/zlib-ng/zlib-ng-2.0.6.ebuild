# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Worth keeping an eye on 'develop' branch upstream for possible backports,
# as they copied this practice from sys-libs/zlib upstream.

inherit cmake

DESCRIPTION="Fork of the zlib data compression library"
HOMEPAGE="https://github.com/zlib-ng/zlib-ng"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

CPU_USE=( cpu_flags_{x86_{avx2,sse2,ssse3,sse4a,pclmul},arm_{crc32,neon},ppc_vsx2} )
IUSE="compat ${CPU_USE[@]} test"

RESTRICT="!test? ( test )"

RDEPEND="compat? ( !sys-libs/zlib )"

src_configure() {
	local mycmakeargs=(
		-DZLIB_COMPAT="$(usex compat)"
		-DZLIB_ENABLE_TESTS="$(usex test)"
		# Unaligned access is controversial and undefined behaviour
		# Let's keep it off for now
		# https://github.com/gentoo/gentoo/pull/17167
		-DWITH_UNALIGNED="OFF"
	)

	# The intrinsics options are all defined conditionally, so we need
	# to enable them on/off per-arch here for now.
	if use amd64 || use x86 ; then
		mycmakeargs+=(
			-DWITH_AVX2=$(usex cpu_flags_x86_avx2)
			-DWITH_SSE2=$(usex cpu_flags_x86_sse2)
			-DWITH_SSSE3=$(usex cpu_flags_x86_ssse3)
			-DWITH_SSE4=$(usex cpu_flags_x86_sse4a)
			-DWITH_PCLMULQDQ=$(usex cpu_flags_x86_pclmul)
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
			-DWITH_POWER8=$(usex cpu_flags_ppc_vsx2)
		)
	fi

	# TODO: There's no s390x USE_EXPAND yet

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use compat ; then
		ewarn "zlib-ng is experimental and replacing the system zlib is dangerous"
		ewarn "Please be careful!"
		ewarn
		ewarn "The following link explains the guarantees (and what is NOT guaranteed):"
		ewarn "https://github.com/zlib-ng/zlib-ng/blob/2.0.x/PORTING.md"
	fi
}
