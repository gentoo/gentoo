# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="ncurses interface for QEMU"
HOMEPAGE="https://unixdev.ru/nemu"
SRC_URI="http://unixdev.ru/src/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+vnc debug"

RDEPEND="
	virtual/udev
	virtual/libusb:1=
	dev-db/sqlite:3=
	sys-libs/ncurses:0=[unicode]
	app-emulation/qemu[vnc]
	vnc? ( net-misc/tigervnc )"

DEPEND="
	${RDEPEND}
	sys-devel/gettext"

src_configure() {
	local mycmakeargs=(
		-DNM_WITH_VNC_CLIENT=$(usex vnc)
		-DNM_DEBUG=$(usex debug)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	elog "Old database is not supported (nEMU versions < 1.0.0)."
	elog "You will need to delete current database."
	elog "If upgraded from 1.0.0, execute script:"
	elog "/usr/share/nemu/scripts/upgrade_db.sh"
}
