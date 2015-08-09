# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
