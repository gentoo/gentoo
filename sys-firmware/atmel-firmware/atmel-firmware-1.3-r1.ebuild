# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-firmware/atmel-firmware/atmel-firmware-1.3-r1.ebuild,v 1.1 2013/02/13 18:45:26 ssuominen Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Firmware and config for atmel and atmel_cs wlan drivers included in linux 2.6"
HOMEPAGE="http://www.thekelleys.org.uk/atmel/"
SRC_URI="http://www.thekelleys.org.uk/atmel/${P}.tar.gz"

LICENSE="Atmel"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="pcmcia usb"

RDEPEND=">=net-wireless/wireless-tools-26-r1
	pcmcia? ( sys-apps/pcmciautils )"

src_compile() {
	tc-export CC
	emake atmel_fwl
}

src_install() {
	# atmel_at76c504c-wpa.bin should be renamed to atmel_at76c504-wpa.bin, bug #398803
	mv images/atmel_at76c504c-wpa.bin images/atmel_at76c504-wpa.bin || die

	insinto /lib/firmware
	doins images/*.bin

	if use usb; then
		doins images.usb/*.bin
	fi

	if use pcmcia; then
		insinto /etc/pcmcia
		doins atmel.conf
	fi

	dosbin atmel_fwl atmel_fwl.pl
	doman atmel_fwl.8
	dodoc README VERSION
}

pkg_postinst() {
	if use pcmcia && [ -f /var/run/cardmgr.pid ]; then
		kill -HUP `cat /var/run/cardmgr.pid`
	fi
}

pkg_postrm() {
	if use pcmcia && [ -f /var/run/cardmgr.pid ]; then
		kill -HUP `cat /var/run/cardmgr.pid`
	fi
}
