# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

EGIT_COMMIT="5a4ef795b297ed1eaf6b4d4e71b3ce7a1bb63481"

DESCRIPTION="EEPROM and microcontroller programmer/flasher"
HOMEPAGE="https://github.com/lancos/ponyprog/"
SRC_URI="https://github.com/lancos/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	>=app-editors/qhexedit2-0.8.10
	<app-editors/qhexedit2-0.9.0
	dev-embedded/libftdi:1[cxx]
	dev-qt/qtbase:6[gui,widgets]
	dev-qt/qtmultimedia:6
	virtual/libusb:1
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-cyrillic.patch
	"${FILESDIR}"/${P}-fix-build-system.patch
	"${FILESDIR}"/${P}-usbwatcher-qt6.patch
)

pkg_postinst() {
	udev_reload

	elog "To use the COM port in user mode (not as root), you need to"
	elog "be in the 'uucp' group."
	elog
	elog "To use the LPT port in user mode (not as root) you need a kernel with"
	elog "ppdev, parport and parport_pc compiled in or as modules. You need the"
	elog "rights to write to /dev/parport? devices."
}

pkg_postrm() {
	udev_reload
}
