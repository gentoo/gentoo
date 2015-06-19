# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-firmware/iwl6050-ucode/iwl6050-ucode-9.201.4.1.ebuild,v 1.2 2012/10/03 19:35:09 vapier Exp $

MY_PN="iwlwifi-6050-ucode"

DESCRIPTION="Intel (R) Wireless WiFi Link 6250-AGN ucode"
HOMEPAGE="http://intellinuxwireless.org/?p=iwlwifi"
SRC_URI="http://intellinuxwireless.org/iwlwifi/downloads/${MY_PN}-${PV}.tgz"

LICENSE="ipw3945"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() { :; }

src_install() {
	insinto /lib/firmware
	doins iwlwifi-6050-4.ucode || die

	dodoc README* || die "dodoc failed"
}
