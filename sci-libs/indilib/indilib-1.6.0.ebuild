# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="lib${PN/lib/}"

inherit cmake-utils udev

DESCRIPTION="INDI Astronomical Control Protocol library"
HOMEPAGE="http://www.indilib.org/"
SRC_URI="https://github.com/${PN}/${PN/lib/}/releases/download/v${PV}/${MY_PN}_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2+ LGPL-2+ LGPL-2.1+"
SLOT="0/1"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="ogg test"

RDEPEND="
	net-misc/curl
	sci-libs/cfitsio:=
	sci-libs/gsl:=
	sci-libs/libnova
	sys-libs/zlib:=
	virtual/jpeg:0
	virtual/libusb:0
	ogg? (
		media-libs/libogg
		media-libs/libtheora
	)
"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	test? (
		dev-cpp/gmock
		dev-cpp/gtest
	)
"

DOCS=( AUTHORS ChangeLog COPYRIGHT README TODO )

S=${WORKDIR}/${MY_PN}

src_test() {
	BUILD_DIR="${BUILD_DIR}"/test cmake-utils_src_test
}

src_configure() {
	local mycmakeargs=(
		-DINDI_BUILD_QT5_CLIENT=OFF
		-DINDI_BUILD_UNITTESTS=$(usex test)
		-DUDEVRULES_INSTALL_DIR="$(get_udevdir)"
		$(cmake-utils_use_find_package ogg OggTheora)
	)

	cmake-utils_src_configure
}
