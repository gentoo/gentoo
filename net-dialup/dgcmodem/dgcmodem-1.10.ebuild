# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/dgcmodem/dgcmodem-1.10.ebuild,v 1.3 2010/10/06 20:05:57 maekke Exp $

inherit linux-info

DESCRIPTION="Driver for Connexant DGC modems"
HOMEPAGE="http://www.linuxant.com/drivers/dgc/"
SRC_URI="http://www.linuxant.com/drivers/dgc/archive/${P}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=""
RDEPEND=""

CONFIG_CHECK="~USB_ACM"
ERROR_USB_ACM="${PN} requires USB modem (CDC ACM) support in your kernel (module name: USB_ACM)".

src_compile() {
	cd "${S}"/scripts
	emake dgcconfig dgcdcpd dgcmodconflicts dgcstop || die "Failed to make scripts"
}

src_install() {
	rm -f modules/GPL/COPYING
	rm -rf modules/binaries
	insinto /usr/lib/dgcmodem
	doins -r modules config.mak || die "Failed to install module files"
	fperms u+x /usr/lib/dgcmodem/modules/kernelcompiler.sh

	cd "${S}"/scripts
	dosbin dgcconfig dgcdcpd dgcmodconflicts dgcstop || die "Failed to install scripts"

	echo 'KERNEL=="ttyACM0", SYMLINK="modem"' > "${D}"/etc/udev/rules.d/90-dgcmodem.rules

	keepdir /etc/dgcmodem
}

pkg_postinst() {
	ewarn "Users need to be in the uucp group to use this driver."
	ewarn
	ewarn "Do not set the baud rate to a value higher than 115200, or it will not work."
	elog
	elog "Please run:"
	elog "    emerge --config ${PN}"
	elog "now and every time you update your kernel."
	elog
	elog "Note that using dgcconfig with default options may install an undesirable"
	elog "rc script, so it is advised you always use the above command instead."
}

pkg_config(){
	dgcconfig --kernel --serial --info
}

pkg_prerm() {
	dgcconfig --remove
	rm -f /etc/dgcmodem/.serial_configured
}
