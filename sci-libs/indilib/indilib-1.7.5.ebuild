# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils udev

DESCRIPTION="INDI Astronomical Control Protocol library"
HOMEPAGE="https://www.indilib.org/"
# SRC_URI="https://github.com/${PN}/${PN/lib/}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${P}.tar.xz"

LICENSE="BSD GPL-2+ LGPL-2+ LGPL-2.1+"
SLOT="0/1"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="ogg test"

RDEPEND="
	net-misc/curl
	sci-libs/cfitsio:=
	sci-libs/gsl:=
	sci-libs/libnova
	sys-libs/zlib
	virtual/jpeg:0
	virtual/libusb:0
	ogg? (
		media-libs/libogg
		media-libs/libtheora
	)
"
DEPEND="${RDEPEND}
	kernel_linux? ( sys-kernel/linux-headers )
	test? ( >=dev-cpp/gtest-1.8.0 )
"

S="${WORKDIR}/lib${PN/lib/}"

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
