# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="lib${PN/lib/}"

inherit cmake-utils udev

DESCRIPTION="INDI Astronomical Control Protocol library"
HOMEPAGE="http://www.indilib.org/"
SRC_URI="https://github.com/${PN}/${PN/lib/}/releases/download/v${PV}/${MY_PN}_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0/1"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND="
	net-misc/curl
	sci-libs/cfitsio
	sci-libs/gsl
	sci-libs/libnova
	sys-libs/zlib
	virtual/jpeg:0
	virtual/libusb:0
"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
"

DOCS=( AUTHORS ChangeLog README TODO )

S=${WORKDIR}/${MY_PN}

src_configure() {
	local mycmakeargs=(
		-INDI_BUILD_UNITTESTS=OFF
		-INDI_BUILD_QT5_CLIENT=OFF
		-DUDEVRULES_INSTALL_DIR="$(get_udevdir)"
	)

	cmake-utils_src_configure
}
