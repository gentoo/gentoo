# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit linux-mod

DESCRIPTION="The lego mindstorms usb tower headers and/or modules"
SRC_URI="mirror://sourceforge/legousb/${P}.tar.gz"
HOMEPAGE="http://legousb.sourceforge.net/"

SLOT="0"
LICENSE="MPL-1.0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_compile()
{
	if [ ${KV_MINOR} -eq 4 ] ; then
		econf || die "Configuration failed"
		emake || die "Compilation failed"
	fi
}

src_install() {
	if [ ${KV_MINOR} -eq 4 ] ; then
		einstall || die "Make Install Failed"
	else
		insinto /usr/include/LegoUSB
		doins include/legousbtower.h
		insinto /lib/udev/rules.d
		doins "${FILESDIR}"/20-lego.rules
	fi
	dodoc README
}

pkg_postinst() {
	if [ ${KV_MINOR} -eq 4 ] ; then
		elog "You are using the 2.4 kernel series."
		elog "These are unsupported."
	else
		elog "You are using the 2.6 kernel series."
		elog "This package only provides the header file."
		elog "You need to enable the lego usb tower option in the kernel."
	fi
}
