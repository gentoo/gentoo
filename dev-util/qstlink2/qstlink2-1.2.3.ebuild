# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QTUSB_VER=0.2.1
inherit qmake-utils udev

DESCRIPTION="GUI and CLI ST-Link V2(Debugger/Programmer) client"
HOMEPAGE="https://github.com/fpoussin/QStlink2/"
SRC_URI="https://github.com/fpoussin/QStlink2/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/fpoussin/QtUsb/archive/v${QTUSB_VER}.tar.gz -> qtusb-${QTUSB_VER}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	virtual/libusb:1
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/QStlink2-${PV}"

src_prepare() {
	rmdir QtUsb || die
	mv "${WORKDIR}/QtUsb-${QTUSB_VER}" QtUsb || die

	default

	sed -i QStlink2.pro -e "s:/etc/udev:$(get_udevdir):" || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
