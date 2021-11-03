# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

DESCRIPTION="INDI Astronomical Control Protocol library"
HOMEPAGE="https://www.indilib.org/"
SRC_URI="https://github.com/${PN}/${PN/lib/}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/lib/}"

LICENSE="BSD GPL-2+ LGPL-2+ LGPL-2.1+"
SLOT="0/1"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="ogg rtlsdr test websocket"

RESTRICT="!test? ( test )"

RDEPEND="
	net-misc/curl
	sci-libs/cfitsio:=
	sci-libs/fftw:3.0=
	sci-libs/gsl:=
	sci-libs/libnova:=
	sys-libs/zlib
	virtual/jpeg:0
	virtual/libusb:0
	ogg? (
		media-libs/libogg
		media-libs/libtheora
	)
	rtlsdr? ( net-wireless/rtl-sdr )
	websocket? ( dev-libs/boost:= )
"
DEPEND="${RDEPEND}
	kernel_linux? ( sys-kernel/linux-headers )
	test? ( >=dev-cpp/gtest-1.8.0 )
	websocket? ( dev-cpp/websocketpp )
"

src_configure() {
	local mycmakeargs=(
		-DINDI_BUILD_QT5_CLIENT=OFF
		-DUDEVRULES_INSTALL_DIR="${EPREFIX}$(get_udevdir)"/rules.d
		$(cmake_use_find_package ogg OggTheora)
		$(cmake_use_find_package rtlsdr RTLSDR)
		-DINDI_BUILD_UNITTESTS=$(usex test)
		-DINDI_BUILD_WEBSOCKET=$(usex websocket)
	)

	cmake_src_configure
}

src_test() {
	BUILD_DIR="${BUILD_DIR}"/test cmake_src_test
}
