# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="High-level, multiplatform C++ network packet sniffing and crafting library"
HOMEPAGE="https://libtins.github.io/"
SRC_URI="https://github.com/mfontanini/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ack-tracker +wifi +wpa2"

REQUIRED_USE="
	wpa2? ( wifi )
"

DEPEND="
	ack-tracker? ( dev-libs/boost:= )
	net-libs/libpcap
	wpa2? ( dev-libs/openssl:0 )
"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DLIBTINS_ENABLE_ACK_TRACKER="$(usex ack-tracker)"
		-DLIBTINS_ENABLE_DOT11="$(usex wifi)"
		-DLIBTINS_ENABLE_WPA2="$(usex wpa2)"
	)

	cmake-utils_src_configure
}
