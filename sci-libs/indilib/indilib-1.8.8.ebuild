# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake udev

DESCRIPTION="INDI Astronomical Control Protocol library"
HOMEPAGE="https://www.indilib.org/"
SRC_URI="https://github.com/${PN}/${PN/lib/}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2+ LGPL-2+ LGPL-2.1+"
SLOT="0/1"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="ogg test websocket"

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
	websocket? ( dev-libs/boost:= )
"
DEPEND="${RDEPEND}
	kernel_linux? ( sys-kernel/linux-headers )
	test? ( >=dev-cpp/gtest-1.8.0 )
	websocket? ( dev-cpp/websocketpp )
"

RESTRICT="!test? ( test )"

S="${WORKDIR}/${P/lib/}"

src_configure() {
	local mycmakeargs=(
		-DINDI_BUILD_QT5_CLIENT=OFF
		-DINDI_BUILD_UNITTESTS=$(usex test)
		-DUDEVRULES_INSTALL_DIR="${EPREFIX}$(get_udevdir)"/rules.d
		$(cmake_use_find_package ogg OggTheora)
		-DINDI_BUILD_WEBSOCKET=$(usex websocket)
	)

	cmake_src_configure
}

src_test() {
	BUILD_DIR="${BUILD_DIR}"/test cmake_src_test
}
