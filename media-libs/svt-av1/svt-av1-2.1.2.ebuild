# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder)"
HOMEPAGE="https://gitlab.com/AOMediaCodec/SVT-AV1"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/AOMediaCodec/SVT-AV1.git"
else
	SRC_URI="https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v${PV}/SVT-AV1-v${PV}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
	S="${WORKDIR}/SVT-AV1-v${PV}"
fi

# Also see "Alliance for Open Media Patent License 1.0"
LICENSE="BSD-2 Apache-2.0 BSD ISC LGPL-2.1+ MIT"
SLOT="0/$(ver_cut 1)"

BDEPEND="amd64? ( dev-lang/yasm )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.0-fortify-no-override.patch
)

multilib_src_configure() {
	append-ldflags -Wl,-z,noexecstack

	local mycmakeargs=(
		# Tests require linking against https://github.com/Cidana-Developers/aom/tree/av1-normative ?
		# undefined reference to `ifd_inspect'
		# https://github.com/Cidana-Developers/aom/commit/cfc5c9e95bcb48a5a41ca7908b44df34ea1313c0
		# .. and https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/master/.gitlab/workflows/linux/.gitlab-ci.yml implies it's all quite manual?
		-DBUILD_TESTING=OFF
		-DCMAKE_OUTPUT_DIRECTORY="${BUILD_DIR}"
		-DENABLE_AVX512=ON
	)

	[[ ${ABI} != amd64 ]] && mycmakeargs+=( -DCOMPILE_C_ONLY=ON )

	cmake_src_configure
}
