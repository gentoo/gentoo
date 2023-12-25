# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

DESCRIPTION="INDI Astronomical Control Protocol library"
HOMEPAGE="https://www.indilib.org/"
SRC_URI="https://github.com/${PN}/${PN/lib/}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/lib/}"

LICENSE="BSD GPL-2+ LGPL-2+ LGPL-2.1+"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
IUSE="ogg rtlsdr test websocket"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/cpp-httplib:=
	dev-libs/libev
	media-libs/libjpeg-turbo:=
	net-misc/curl
	sci-libs/cfitsio:=
	sci-libs/fftw:3.0=
	sci-libs/gsl:=
	sci-libs/libnova:=
	sys-libs/zlib
	virtual/libusb:1
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

PATCHES=( "${FILESDIR}/${P}-link-system-httplib.patch" )

src_configure() {
	local mycmakeargs=(
		-DINDI_SYSTEM_HTTPLIB=ON
		-DINDI_BUILD_QT5_CLIENT=OFF
		-DINDI_BUILD_SHARED=ON
		-DINDI_BUILD_STATIC=OFF
		-DINDI_BUILD_XISF=OFF # not packaged
		-DUDEVRULES_INSTALL_DIR="${EPREFIX}$(get_udevdir)"/rules.d
		$(cmake_use_find_package ogg OggTheora)
		$(cmake_use_find_package rtlsdr RTLSDR)
		-DINDI_BUILD_UNITTESTS=$(usex test)
		-DINDI_BUILD_INTEGTESTS=$(usex test)
		-DINDI_BUILD_WEBSOCKET=$(usex websocket)
	)

	cmake_src_configure
}

src_test() {
	# Unit tests
	BUILD_DIR="${BUILD_DIR}"/test cmake_src_test

	# Integration tests
	# They fail in parallel because they try to bind to the same port more
	# than once.
	BUILD_DIR="${BUILD_DIR}"/integs cmake_src_test -j1
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
