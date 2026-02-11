# Copyright 2018-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Library for Reliable Internet Stream Transport (RIST) protocol"
HOMEPAGE="https://code.videolan.org/rist/librist"
SRC_URI="https://code.videolan.org/rist/librist/-/archive/v${PV}/librist-v${PV}.tar.bz2"
S="${WORKDIR}/librist-v${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test tools"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( tools )"

RDEPEND="
	tools? ( net-libs/libmicrohttpd )
	dev-libs/cJSON
	net-libs/mbedtls:3=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/cmake
	dev-util/cmocka
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/librist-0.2.11-mbedtls-3.patch"
)

src_configure() {
	local emesonargs=(
		$(meson_use test)
		$(meson_use tools built_tools)
		$(meson_use tools use_tun)
		-Dstatic_analyze=false
		-Dbuiltin_cjson=false
		-Dbuiltin_mbedtls=false
		-Dfallback_builtin=false
		-Duse_mbedtls=true
		-Duse_nettle=false
	)
	meson_src_configure
}

src_test() {
	# multicast tests fails with FEATURES=network-sandbox
	meson_src_test --no-suite multicast
}
