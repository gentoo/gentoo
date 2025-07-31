# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib edo multiprocessing

DESCRIPTION="Scalable Video Technology for AV1 (SVT-AV1 Encoder)"
HOMEPAGE="https://gitlab.com/AOMediaCodec/SVT-AV1"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/AOMediaCodec/SVT-AV1.git"
else
	SRC_URI="https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v${PV}/SVT-AV1-v${PV}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
	S="${WORKDIR}/SVT-AV1-v${PV}"
fi

# Also see "Alliance for Open Media Patent License 1.0"
LICENSE="BSD-2 Apache-2.0 BSD ISC LGPL-2.1+ MIT"
SLOT="0/$(ver_cut 1)"

IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	amd64? ( dev-lang/yasm )
	test? ( dev-util/gtest-parallel )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.0-fortify-no-override.patch
)

src_prepare() {
	cmake_src_prepare

	# Lets not install tests
	sed -e '/install(/d' -i test/CMakeLists.txt || die

	# Needs more setup to run in the ebuild
	cmake_run_in test cmake_comment_add_subdirectory api_test
	# Tries to download stuff for this test
	cmake_run_in test cmake_comment_add_subdirectory e2e_test
}

multilib_src_configure() {
	local mycmakeargs=(
		# Upstream only supports 64-bit and specially amd64 and arm64.
		# Other enviroments will fail to build due to missing symbols.
		-DBUILD_TESTING=$(multilib_native_usex test)
		-DCMAKE_OUTPUT_DIRECTORY="${BUILD_DIR}"
	)

	[[ ${ABI} != amd64 ]] && mycmakeargs+=( -DCOMPILE_C_ONLY=ON )

	cmake_src_configure
}

multilib_src_test() {
	if multilib_is_native_abi; then
		# Upstream uses this, and this gives a significant time save in running these tests.
		# 2025-05-19T19:39:25 >>> media-libs/svt-av1-3.0.2: 1:46:14
		# 2025-05-20T16:10:34 >>> media-libs/svt-av1-3.0.2: 20′35″
		edo gtest-parallel --workers "$(makeopts_jobs)" "${BUILD_DIR}"/SvtAv1UnitTests
	fi
}
