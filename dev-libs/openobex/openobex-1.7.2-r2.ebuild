# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils udev

DESCRIPTION="Implementation of the OBEX protocol used for transferring data to mobile devices"
HOMEPAGE="https://sourceforge.net/projects/openobex/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-Source.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/2"
KEYWORDS="amd64 arm ~hppa ppc ppc64 ~sparc x86"
IUSE="bluetooth doc irda usb"

BDEPEND="
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"
DEPEND="
	bluetooth? ( net-wireless/bluez:= )
	usb? ( virtual/libusb:= )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-Source"

PATCHES=( "${FILESDIR}/${P}-version.h.patch" )
DOCS=( AUTHORS ChangeLog README UPGRADING.txt )

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DOPENOBEX_BLUETOOTH=$(usex bluetooth)
		-DOPENOBEX_IRDA=$(usex irda)
		-DOPENOBEX_USB=$(usex usb)
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
	)
	use usb && mycmakeargs+=( -DCMAKE_INSTALL_UDEVRULESDIR="$(get_udevdir)/rules.d" )

	cmake-utils_src_configure
}
