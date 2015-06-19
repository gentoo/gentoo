# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libticables2/libticables2-1.3.4.ebuild,v 1.1 2013/07/09 16:42:43 bicatali Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Library to handle different link cables for TI calculators"
HOMEPAGE="http://lpg.ticalc.org/prj_tilp/"
SRC_URI="mirror://sourceforge/tilp/tilp2-linux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug doc nls static-libs usb"

RDEPEND="
	dev-libs/glib:2
	usb? ( virtual/libusb:1 )
	nls? ( virtual/libintl )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS LOGO NEWS README ChangeLog docs/api.txt )

src_configure() {
	# --disable-libusb $(use_enable usb libusb10) would enable virtual/libusb:1
	local myeconfargs=(
		--disable-rpath
		$(use_enable debug logging)
		$(use_enable nls)
		$(use_enable usb libusb)
		$(use_enable usb libusb10)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use doc && dohtml docs/html/*
}

pkg_postinst() {
	elog "Please read README in /usr/share/doc/${PF}"
	elog "if you encounter any problem with a link cable"
}
