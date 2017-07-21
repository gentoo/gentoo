# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="lib${PN/lib/}"

inherit cmake-utils udev

DESCRIPTION="INDI Astronomical Control Protocol library"
HOMEPAGE="http://www.indilib.org/"
SRC_URI="mirror://sourceforge/${PN/lib/}/${PN/lib/}-${PV}.zip"

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
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	sys-kernel/linux-headers
"

DOCS=( AUTHORS ChangeLog README TODO )

S=${WORKDIR}/${PN/lib/}-${PV}/${MY_PN}

src_configure() {
	local mycmakeargs=(
		-INDI_BUILD_UNITTESTS=OFF
		-DUDEVRULES_INSTALL_DIR="$(get_udevdir)"
	)

	cmake-utils_src_configure
}
