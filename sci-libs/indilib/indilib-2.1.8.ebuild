# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake dot-a udev

DESCRIPTION="INDI Astronomical Control Protocol library"
HOMEPAGE="https://www.indilib.org/"
SRC_URI="https://github.com/${PN}/${PN/lib/}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/lib/}"

LICENSE="BSD GPL-2+ LGPL-2+ LGPL-2.1+"
SLOT="0/1"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="ogg rtlsdr test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/cpp-httplib:=
	dev-cpp/nlohmann_json
	dev-libs/hidapi
	dev-libs/libev
	media-libs/libjpeg-turbo:=
	net-misc/curl
	sci-libs/cfitsio:=
	sci-libs/fftw:3.0=
	sci-libs/gsl:=
	sci-libs/libnova:=
	virtual/zlib:=
	virtual/libusb:1
	ogg? (
		media-libs/libogg
		media-libs/libtheora:=
	)
	rtlsdr? ( net-wireless/rtl-sdr:= )
"
DEPEND="${RDEPEND}
	kernel_linux? ( sys-kernel/linux-headers )
	test? ( >=dev-cpp/gtest-1.8.0 )
"

src_configure() {
	lto-guarantee-fat

	local mycmakeargs=(
		-DINDI_SYSTEM_HIDAPILIB=ON
		-DINDI_SYSTEM_HTTPLIB=ON
		-DINDI_SYSTEM_JSONLIB=ON
		-DINDI_BUILD_QT_CLIENT=OFF
		-DINDI_BUILD_SHARED=ON
		-DINDI_BUILD_STATIC=OFF
		-DINDI_BUILD_XISF=OFF # not packaged
		-DUDEVRULES_INSTALL_DIR="${EPREFIX}$(get_udevdir)"/rules.d
		-DINDI_BUILD_EXAMPLES=OFF # nothing is installed
		$(cmake_use_find_package ogg OggTheora)
		$(cmake_use_find_package rtlsdr RTLSDR)
		-DINDI_BUILD_UNITTESTS=$(usex test)
		-DINDI_BUILD_INTEGTESTS=$(usex test)
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

src_install() {
	cmake_src_install
	strip-lto-bytecode
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
