# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

QHEXEDIT2_HASH="64f50820118c450ab49ae63bfd9b143eb1971058"

DESCRIPTION="EEPROM and microcontroller programmer/flasher"
HOMEPAGE="https://github.com/lancos/ponyprog/"
SRC_URI="https://github.com/lancos/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/lancos/qhexedit2/archive/${QHEXEDIT2_HASH}.tar.gz  -> qhexedit2-${P}.tar.gz
"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

# blocker on libftdi-1.5-r2: see #775116
RDEPEND="dev-embedded/libftdi:1[cxx]
	!=dev-embedded/libftdi-1.5-r2
	virtual/libusb:1
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtprintsupport:5"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.1-fix-build-system.patch
)

src_unpack() {
	default
	mv qhexedit2-*/src ${P}/qhexedit2/ || die "moving qhexedit2 failed"
}

src_configure() {
	local mycmakeargs=( -DCMAKE_INSTALL_DOCDIR="share/doc/${PF}" )
	cmake_src_configure
}

pkg_postinst() {
	elog "To use the COM port in user mode (not as root), you need to"
	elog "be in the 'uucp' group."
	elog
	elog "To use the LPT port in user mode (not as root) you need a kernel with"
	elog "ppdev, parport and parport_pc compiled in or as modules. You need the"
	elog "rights to write to /dev/parport? devices."
}
