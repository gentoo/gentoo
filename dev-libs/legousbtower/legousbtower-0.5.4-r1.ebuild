# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info

DESCRIPTION="The lego mindstorms usb tower headers and/or modules"
SRC_URI="mirror://sourceforge/legousb/${P}.tar.gz"
HOMEPAGE="http://legousb.sourceforge.net/"

SLOT="0"
LICENSE="MPL-1.0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_configure() {
	if kernel_is -lt 2 5 ; then
		econf
	fi
}
src_compile()
{
	if kernel_is -lt 2 5 ; then
		emake
	fi
}

src_install() {
	if kernel_is -lt 2 5 ; then
		einstall
	else
		insinto /usr/include/LegoUSB
		doins include/legousbtower.h
		insinto /lib/udev/rules.d
		doins "${FILESDIR}"/20-lego.rules
	fi
	dodoc README
}

pkg_postinst() {
	if kernel_is -lt 2 5 ; then
		elog "You are using the 2.4 kernel series."
		elog "These are unsupported."
	else
		elog "You are using the 2.6 kernel series."
		elog "This package only provides the header file."
		elog "You need to enable the lego usb tower option in the kernel."
	fi
}
