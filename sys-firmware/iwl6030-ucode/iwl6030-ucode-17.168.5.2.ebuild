# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="iwlwifi-6000g2b-ucode"

DESCRIPTION="Intel (R) Wireless WiFi Advanced N 6030 ucode"
HOMEPAGE="http://intellinuxwireless.org/?p=iwlwifi"
SRC_URI="http://intellinuxwireless.org/iwlwifi/downloads/${MY_PN}-${PV}.tgz"

LICENSE="ipw3945"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	insinto /lib/firmware
	doins iwlwifi-6000g2b-5.ucode

	dodoc README*
}
