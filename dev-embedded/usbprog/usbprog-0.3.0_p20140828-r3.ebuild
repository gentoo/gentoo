# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="293d559bac55f7c7130ea2769c703c68a19d62c2"
inherit cmake readme.gentoo-r1

DESCRIPTION="flashtool for the multi purpose programming adapter usbprog"
HOMEPAGE="https://github.com/bwalle/usbprog-tools https://www.aaabbb.de/FirmwareUsbprog/FirmwareUsbprog_en.php"
SRC_URI="https://github.com/bwalle/usbprog-tools/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/usbprog-tools-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gui minimal"

RDEPEND="
	!minimal? (
		gui? ( dev-qt/qtbase:6[widgets] )
		dev-qt/qtbase:6[network,xml]
		sys-libs/ncurses:=
		sys-libs/readline:=
	)
	virtual/libusb:1
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}_versions.xml.patch"
	"${FILESDIR}/${P}-cmake4-qt6.patch" # bug #965714
)

DOC_CONTENTS="
Please visit http://www.aaabbb.de/FirmwareUsbprog/FirmwareUsbprog_en.php
for additional info.
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_ONLY_CORE=$(usex minimal)
		-DBUILD_GUI=$(usex gui)
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
