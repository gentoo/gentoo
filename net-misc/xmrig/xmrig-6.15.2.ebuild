# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake systemd

DESCRIPTION="RandomX, CryptoNight, KawPow, AstroBWT, and Argon2 CPU/GPU miner"
HOMEPAGE="https://xmrig.com https://github.com/xmrig/xmrig"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/xmrig/xmrig/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64"
fi

LICENSE="Apache-2.0 GPL-3+ MIT"
SLOT="0"
IUSE="cpu_flags_x86_sse4_1 donate hwloc opencl +ssl"

DEPEND="
	dev-libs/libuv:=
	hwloc? ( sys-apps/hwloc:= )
	opencl? ( virtual/opencl )
	ssl? ( dev-libs/openssl:= )
"
RDEPEND="
	${DEPEND}
	!arm64? ( sys-apps/msr-tools )
"

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
		-DWITH_SSE4_1=$(usex cpu_flags_x86_sse4_1)
		-DWITH_HWLOC=$(usex hwloc)
		-DWITH_TLS=$(usex ssl)
		-DWITH_OPENCL=$(usex opencl)
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
