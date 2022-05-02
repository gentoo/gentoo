# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

DESCRIPTION="EEPROM and microcontroller programmer/flasher"
HOMEPAGE="https://github.com/lancos/ponyprog/"
SRC_URI="https://github.com/lancos/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	>app-editors/qhexedit2-0.8.8_p20200625
	dev-embedded/libftdi:1[cxx]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	virtual/libusb:1
"
# blocker on libftdi-1.5-r2: see #775116
RDEPEND="${DEPEND}
	!=dev-embedded/libftdi-1.5-r2
"

PATCHES=( "${FILESDIR}"/${P}-fix-build-system.patch )

pkg_postinst() {
	udev_reload

	elog "To use the COM port in user mode (not as root), you need to"
	elog "be in the 'uucp' group."
	elog
	elog "To use the LPT port in user mode (not as root) you need a kernel with"
	elog "ppdev, parport and parport_pc compiled in or as modules. You need the"
	elog "rights to write to /dev/parport? devices."
}
