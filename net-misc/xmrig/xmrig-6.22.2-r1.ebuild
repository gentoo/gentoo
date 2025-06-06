# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd

DESCRIPTION="RandomX, KawPow, CryptoNight & GhostRider CPU/GPU miner"
HOMEPAGE="https://xmrig.com"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/xmrig/xmrig/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-3+ Apache-2.0 BSD BSD-2 MIT" # main, base32, epee, getopt, adl
SLOT="0"
IUSE="benchmark donate hwloc opencl +ssl"
IUSE+=" cpu_flags_x86_avx2 cpu_flags_x86_sse4_1"

DEPEND="
	dev-libs/libuv:=
	hwloc? ( >=sys-apps/hwloc-2.5.0:= )
	opencl? ( virtual/opencl )
	ssl? ( dev-libs/openssl:= )
"
RDEPEND="
	${DEPEND}
	!arm64? ( sys-apps/msr-tools )
"
DOCS=( {CHANGELOG,README}.md )

PATCHES=(
	"${FILESDIR}"/${PN}-6.12.2-nonotls.patch
)

src_prepare() {
	if ! use donate ; then
		sed -i 's/1;/0;/g' src/donate.h || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_AVX2=$(usex cpu_flags_x86_avx2)
		-DWITH_SSE4_1=$(usex cpu_flags_x86_sse4_1)
		-DWITH_BENCHMARK=$(usex benchmark)
		-DWITH_HWLOC=$(usex hwloc)
		-DWITH_TLS=$(usex ssl)
		-DWITH_OPENCL=$(usex opencl)
		# https://github.com/xmrig/xmrig-cuda?tab=readme-ov-file#xmrig-cuda
		-DWITH_CUDA=OFF
	)

	cmake_src_configure
}

src_install() {
	default
	keepdir /etc/xmrig
	systemd_dounit "${FILESDIR}"/xmrig.service
	dobin "${BUILD_DIR}/xmrig"
	dobin "${S}/scripts/enable_1gb_pages.sh"
	dobin "${S}/scripts/randomx_boost.sh"
}
