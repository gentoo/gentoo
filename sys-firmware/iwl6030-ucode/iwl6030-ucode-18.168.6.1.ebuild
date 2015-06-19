# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-firmware/iwl6030-ucode/iwl6030-ucode-18.168.6.1.ebuild,v 1.2 2012/10/03 19:34:33 vapier Exp $

MY_PN="iwlwifi-6000g2b-ucode"

DESCRIPTION="Intel (R) Wireless WiFi Advanced N 6030 ucode"
HOMEPAGE="http://intellinuxwireless.org/?p=iwlwifi"
SRC_URI="http://intellinuxwireless.org/iwlwifi/downloads/${MY_PN}-${PV}.tgz"

LICENSE="ipw3945"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() { :; }

src_install() {
	insinto /lib/firmware
	doins "${S}/iwlwifi-6000g2b-6.ucode" || die

	dodoc README* || die "dodoc failed"
}
