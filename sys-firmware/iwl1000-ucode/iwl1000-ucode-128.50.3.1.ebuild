# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-firmware/iwl1000-ucode/iwl1000-ucode-128.50.3.1.ebuild,v 1.2 2012/10/03 19:32:13 vapier Exp $

EAPI=4
MY_P="iwlwifi-1000-ucode-${PV}"

DESCRIPTION="Intel (R) Wireless WiFi Link 1000BGN ucode"
HOMEPAGE="http://intellinuxwireless.org/?p=iwlwifi"
SRC_URI="http://intellinuxwireless.org/iwlwifi/downloads/${MY_P}.tgz"

LICENSE="ipw3945"
SLOT="3"
KEYWORDS=""
IUSE=""

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /lib/firmware
	doins iwlwifi-1000-3.ucode
	dodoc README.iwlwifi-1000-ucode
}
