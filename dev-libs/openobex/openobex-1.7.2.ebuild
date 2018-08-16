# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils udev

DESCRIPTION="Implementation of the OBEX protocol used for transferring data to mobile devices"
HOMEPAGE="https://sourceforge.net/projects/openobex/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-Source.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/2"
KEYWORDS="amd64 ~arm ~hppa ppc ~ppc64 ~sparc x86"
IUSE="bluetooth irda usb"

RDEPEND="
	bluetooth? ( net-wireless/bluez:= )
	usb? ( virtual/libusb:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P}-Source

src_configure() {
	local mycmakeargs=(
		-DOPENOBEX_BLUETOOTH=$(usex bluetooth)
		-DOPENOBEX_IRDA=$(usex irda)
		-DOPENOBEX_USB=$(usex usb)
		# TODO: enable them. patch would be appreciated.
		-DBUILD_DOCUMENTATION=OFF

		-DCMAKE_INSTALL_UDEVRULESDIR="$(get_udevdir)/rules.d"
	)

	cmake-utils_src_configure
}
