# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit cmake-multilib flag-o-matic multiprocessing python-any-r1

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://aomedia.googlesource.com/aom"
else
	# To update test data tarball,
	# chromium-tools.git/generate-libaom-test-tarball.sh
	SRC_URI="
		https://storage.googleapis.com/aom-releases/${P}.tar.gz
		test? ( https://deps.gentoo.zip/${CATEGORY}/${P}-testdata.tar.xz )
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Alliance for Open Media AV1 Codec SDK"
HOMEPAGE="https://aomedia.org https://aomedia.googlesource.com/aom/"

LICENSE="BSD-2"
SLOT="0/3"
IUSE="big-endian debug doc +examples test"
IUSE="${IUSE} cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3"
IUSE="${IUSE} cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2 cpu_flags_x86_avx cpu_flags_x86_avx2"
IUSE="${IUSE} cpu_flags_arm_crc32 cpu_flags_arm_neon cpu_flags_ppc_vsx"
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
	doc? ( app-text/doxygen )
"

# The PATENTS file is required to be distributed with this package, bug #682214
DOCS=( PATENTS )

PATCHES=(
	"${FILESDIR}"/${PN}-3.4.0-posix-c-source-ftello.patch
	"${FILESDIR}"/${PN}-3.7.0-allow-fortify-source.patch
	"${FILESDIR}"/${PN}-3.8.1-tests-parallel.patch
	"${FILESDIR}"/${PN}-3.9.1-gcc15-cstdint.patch
)

multilib_src_configure() {
	# Follow upstream recommendations in README (bug #921438) and avoid
	# asserts during common use (bug #914614).
	append-cppflags $(usex debug '-UNDEBUG' '-DNDEBUG')

	local mycmakeargs=(
		-DENABLE_CCACHE=OFF
		-DENABLE_DOCS=$(multilib_native_usex doc ON OFF)
		-DENABLE_EXAMPLES=$(multilib_native_usex examples ON OFF)
		-DENABLE_NASM=OFF
		-DENABLE_TESTS=$(usex test)
		-DENABLE_TOOLS=ON
		-DENABLE_WERROR=OFF
		# https://bugs.chromium.org/p/aomedia/issues/detail?id=3487 shows
		# that big endian detection doesn't really work otherwise.
		-DCONFIG_BIG_ENDIAN=$(usex big-endian 1 0)

		# Needs libjxl, currently unpackaged.
		-DCONFIG_TUNE_BUTTERAUGLI=0

		# arm
		-DENABLE_NEON=$(usex cpu_flags_arm_neon ON OFF)
		-DENABLE_ARM_CRC32=$(usex cpu_flags_arm_crc32 ON OFF)
		# bug #917277
		-DENABLE_NEON_DOTPROD=OFF
		# bug #917278
		-DENABLE_NEON_I8MM=OFF
		# bug #920474
		-DENABLE_SVE=OFF

		# mips
		# ENABLE_DSPR2 / ENABLE_MSA for mips

		# amd64
		-DENABLE_MMX=$(usex cpu_flags_x86_mmx ON OFF)
		-DENABLE_SSE=$(usex cpu_flags_x86_sse ON OFF)
		-DENABLE_SSE2=$(usex cpu_flags_x86_sse2 ON OFF)
		-DENABLE_SSE3=$(usex cpu_flags_x86_sse3 ON OFF)
		-DENABLE_SSSE3=$(usex cpu_flags_x86_ssse3 ON OFF)
		-DENABLE_SSE4_1=$(usex cpu_flags_x86_sse4_1 ON OFF)
		-DENABLE_SSE4_2=$(usex cpu_flags_x86_sse4_2 ON OFF)
		-DENABLE_AVX=$(usex cpu_flags_x86_avx ON OFF)
		-DENABLE_AVX2=$(usex cpu_flags_x86_avx2 ON OFF)

		# ppc
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

	# LIBAOM_TEST_PROCS is added by our tests-parallel.patch
	export LIBAOM_TEST_PROCS="$(makeopts_jobs)"

	cmake_src_configure
}

multilib_src_test() {
	einfo "Running quiet tests which take hours."
	# We use ninja rather than test_libaom directly so we can run it in parallel
	# with sharding, see https://aomedia.googlesource.com/aom/#sharded-testing.
	LIBAOM_TEST_DATA_PATH="${WORKDIR}/${P}-testdata" eninja -C "${BUILD_DIR}" runtests
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
