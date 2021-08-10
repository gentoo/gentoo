# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake readme.gentoo-r1

REV="293d559bac55"

DESCRIPTION="flashtool for the multi purpose programming adapter usbprog"
HOMEPAGE="http://bwalle.de/website/usbprog.html https://bitbucket.org/bwalle/usbprog-tools/src/master/"
SRC_URI="https://bitbucket.org/bwalle/usbprog-tools/get/${REV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt5"

RDEPEND="qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtxml:5
	)
	sys-libs/ncurses:=
	sys-libs/readline:=
	virtual/libusb:1
"
DEPEND="${RDEPEND}"
S="${WORKDIR}/bwalle-usbprog-tools-${REV}"

DOC_CONTENTS="
Please visit http://www.aaabbb.de/FirmwareUsbprog/FirmwareUsbprog_en.php
for version.xml.
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_GUI=$(usex qt5)
		-DUSE_QT5=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
