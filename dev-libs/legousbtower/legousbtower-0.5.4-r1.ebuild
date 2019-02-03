# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit udev

DESCRIPTION="The lego mindstorms usb tower headers and/or modules"
SRC_URI="mirror://sourceforge/legousb/${P}.tar.gz"
HOMEPAGE="http://legousb.sourceforge.net/"

SLOT="0"
LICENSE="MPL-1.0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto /usr/include/LegoUSB
	doins include/legousbtower.h
	udev_dorules "${FILESDIR}"/20-lego.rules
	dodoc README
}

pkg_postinst() {
	elog "This package only provides the header file."
	elog "You need to enable the lego usb tower option in the kernel."
	elog "The kernel 2.4 module is no longer built or supported"
}
