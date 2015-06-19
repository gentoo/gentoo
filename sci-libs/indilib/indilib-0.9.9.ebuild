# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/indilib/indilib-0.9.9.ebuild,v 1.5 2014/11/28 14:09:42 ago Exp $

EAPI=5

MY_PN="lib${PN/lib/}"

inherit cmake-utils udev

DESCRIPTION="INDI Astronomical Control Protocol library"
HOMEPAGE="http://www.indilib.org/"
SRC_URI="mirror://sourceforge/${PN/lib/}/${MY_PN}_${PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="
	sci-libs/cfitsio
	sci-libs/libnova
	sci-libs/gsl
	sys-libs/zlib
	virtual/jpeg:0
	virtual/libusb:0
"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
"

DOCS=( AUTHORS ChangeLog README TODO )

PATCHES=(
	"${FILESDIR}/${PN}-0.9.8.1-symlinks.patch"
)

S=${WORKDIR}/${MY_PN}_${PV}

src_configure() {
	local mycmakeargs=(
		-DUDEVRULES_INSTALL_DIR=$(get_udevdir)
	)

	cmake-utils_src_configure
}
