# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit cmake-multilib python-any-r1

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://aomedia.googlesource.com/aom"
else
	# To update test data tarball, follow these steps:
	# 1.  Clone the upstream repo and check out the relevant tag,
	#	  or download the release tarball
	# 2.  Regular cmake configure (options don't matter here):
	#     cd build && cmake ..
	# 3.  Set LIBAOM_TEST_DATA_PATH to the directory you want and
	#     run the "make testdata" target:
	#     LIBAOM_TEST_DATA_PATH=../libaom-1.2.3-testdata make testdata
	#     This will download the test data from the internet.
	# 4.  Create a tarball out of that directory.
	#     cd .. && tar cvaf libaom-1.2.3-testdata.tar.xz libaom-1.2.3-testdata
	SRC_URI="
		https://storage.googleapis.com/aom-releases/${P}.tar.gz
		test? ( https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-testdata.tar.xz )
	"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv ~sparc x86"
fi

DESCRIPTION="Alliance for Open Media AV1 Codec SDK"
HOMEPAGE="https://aomedia.org https://aomedia.googlesource.com/aom/"

LICENSE="BSD-2"
SLOT="0/3"
IUSE="doc +examples test"
IUSE="${IUSE} cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3"
IUSE="${IUSE} cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2 cpu_flags_x86_avx cpu_flags_x86_avx2"
IUSE="${IUSE} cpu_flags_arm_neon cpu_flags_ppc_vsx"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	cpu_flags_x86_sse2? ( cpu_flags_x86_mmx )
	cpu_flags_x86_ssse3? ( cpu_flags_x86_sse2 )
"

BDEPEND="${PYTHON_DEPS}
	dev-lang/perl
	abi_x86_32? ( dev-lang/yasm )
	abi_x86_64? ( dev-lang/yasm )
	abi_x86_x32? ( dev-lang/yasm )
	doc? ( app-doc/doxygen )
"

# The PATENTS file is required to be distributed with this package, bug #682214
DOCS=( PATENTS )

PATCHES=(
	"${FILESDIR}"/${PN}-3.4.0-posix-c-source-ftello.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_CCACHE=OFF
		-DENABLE_DOCS=$(multilib_native_usex doc ON OFF)
		-DENABLE_EXAMPLES=$(multilib_native_usex examples ON OFF)
		-DENABLE_NASM=OFF
		-DENABLE_TESTS=$(usex test)
		-DENABLE_TOOLS=ON
		-DENABLE_WERROR=OFF

		# Needs libjxl, currently unpackaged.
		-DCONFIG_TUNE_BUTTERAUGLI=0

		# neon support is assumed to be always enabled on arm64
		-DENABLE_NEON=$(usex cpu_flags_arm_neon ON $(usex arm64 ON OFF))
		# ENABLE_DSPR2 / ENABLE_MSA for mips
		-DENABLE_MMX=$(usex cpu_flags_x86_mmx ON OFF)
		-DENABLE_SSE=$(usex cpu_flags_x86_sse ON OFF)
		-DENABLE_SSE2=$(usex cpu_flags_x86_sse2 ON OFF)
		-DENABLE_SSE3=$(usex cpu_flags_x86_sse3 ON OFF)
		-DENABLE_SSSE3=$(usex cpu_flags_x86_ssse3 ON OFF)
		-DENABLE_SSE4_1=$(usex cpu_flags_x86_sse4_1 ON OFF)
		-DENABLE_SSE4_2=$(usex cpu_flags_x86_sse4_2 ON OFF)
		-DENABLE_AVX=$(usex cpu_flags_x86_avx ON OFF)
		-DENABLE_AVX2=$(usex cpu_flags_x86_avx2 ON OFF)

		-DENABLE_VSX=$(usex cpu_flags_ppc_vsx ON OFF)
	)

	# For 32-bit multilib builds, force some intrinsics on to work around
	# bug #816027. libaom seems to do runtime detection for some targets
	# at least, so this isn't an issue.
	if ! multilib_is_native_abi && use amd64 ; then
		mycmakeargs+=(
			-DENABLE_SSE3=ON
			-DENABLE_SSSE3=ON
		)
	fi

	# On ARM32-on-ARM64, things end up failing if NEON is off, bug #835456
	# Just force generic, given it's a niche situation.
	# TODO: could try forcing armv7 or similar?
	if use arm && ! use cpu_flags_arm_neon && [[ $(uname -p) == "aarch64" ]] ; then
		ewarn "Forcing generic for arm32-on-arm64 build (bug #835456)"
		mycmakeargs+=(
			-DAOM_TARGET_CPU=generic
		)
	fi

	cmake_src_configure
}

multilib_src_test() {
	LIBAOM_TEST_DATA_PATH="${WORKDIR}/${P}-testdata" "${BUILD_DIR}"/test_libaom || die
}

multilib_src_install() {
	if multilib_is_native_abi && use doc ; then
		local HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
	fi

	cmake_src_install
}

multilib_src_install_all() {
	find "${ED}" -type f \( -name "*.a" -o -name "*.la" \) -delete || die
}
