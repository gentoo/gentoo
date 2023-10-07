# Copyright 2018-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Library for Reliable Internet Stream Transport (RIST) protocol"
HOMEPAGE="https://code.videolan.org/rist/librist"

SRC_URI="https://code.videolan.org/rist/librist/-/archive/v${PV}/librist-v${PV}.tar.bz2"
KEYWORDS="~arm64"

LICENSE="BSD-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/cJSON
	net-libs/mbedtls:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/librist-v${PV}"

src_configure() {
	local emesonargs=(
		-Dstatic_analyze=false
		$(meson_use test)
		-Dbuiltin_cjson=false
		-Dbuiltin_mbedtls=false
		# Tools have automagic libmicrohttpd dep for prometheus;
		# needs solved before exposing; look into use_tun once enabled
		-Dbuilt_tools=false
		-Dfallback_builtin=false
		-Duse_mbedtls=true
		-Duse_nettle=false
		-Duse_tun=false # Used only by tools
	)
	meson_src_configure
}

src_test() {
	# multicast tests fails with FEATURES=network-sandbox
	meson_src_test --no-suite multicast
}
