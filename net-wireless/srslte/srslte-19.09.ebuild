# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils vcs-snapshot

MY_PV=${PV/./_}

DESCRIPTION="Open source SDR LTE software suite from Software Radio Systems"
HOMEPAGE="http://www.softwareradiosystems.com"
SRC_URI="https://github.com/srsLTE/srsLTE/archive/release_${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bladerf simcard soapysdr uhd zeromq"

DEPEND="
	dev-libs/boost
	dev-libs/libconfig
	net-misc/lksctp-tools
	net-libs/mbedtls
	sci-libs/fftw:*
	bladerf? ( net-wireless/bladerf:= )
	simcard? ( sys-apps/pcsc-lite )
	soapysdr? ( net-wireless/soapysdr:= )
	uhd? ( net-wireless/uhd:= )
	zeromq? ( net-libs/zeromq )

"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	sed -i '/ -Werror"/d' CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DENABLE_UHD="$(usex uhd)"
		-DENABLE_BLADERF="$(usex bladerf)"
		-DENABLE_SOAPYSDR="$(usex soapysdr)"
		-DENABLE_ZEROMQ="$(usex zeromq)"
		-DENABLE_HARDSIM="$(usex simcard)"
	)
	cmake-utils_src_configure
}
