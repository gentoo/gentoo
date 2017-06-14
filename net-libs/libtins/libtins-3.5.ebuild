# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="High-level, multiplatform C++ network packet sniffing and crafting library."
HOMEPAGE="https://libtins.github.io/"
SRC_URI="https://github.com/mfontanini/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cxx11 +ack-tracker +wpa2 +dot11 static-libs"

REQUIRED_USE="
	wpa2? ( dot11 )
"

DEPEND="
	ack-tracker? ( dev-libs/boost )
	wpa2? ( dev-libs/openssl:0 )
"
RDEPEND="${DEPEND}
	net-libs/libpcap
"

RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
	    -DLIBTINS_ENABLE_CXX11="$(usex cxx11)"
		-DLIBTINS_ENABLE_ACK_TRACKER="$(usex ack-tracker)"
		-DLIBTINS_ENABLE_WPA2="$(usex wpa2)"
		-DLIBTINS_ENABLE_DOT11="$(usex dot11)"
		-DLIBTINS_BUILD_SHARED="$(usex !static-libs)"
	)

	cmake-utils_src_configure
}
