# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="iwlwifi-1000-ucode-${PV}"
DESCRIPTION="Intel (R) Wireless WiFi Link 1000BGN ucode"
HOMEPAGE="https://wireless.wiki.kernel.org/en/users/Drivers/iwlwifi"
SRC_URI="https://wireless.wiki.kernel.org/_media/en/users/drivers/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="ipw3945"
SLOT="0"
KEYWORDS="amd64 x86"

src_install() {
	insinto /lib/firmware
	doins iwlwifi-1000-5.ucode
	dodoc README.iwlwifi-1000-ucode
}
