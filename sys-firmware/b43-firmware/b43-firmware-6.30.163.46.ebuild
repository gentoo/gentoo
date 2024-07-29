# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="broadcom-wl-${PV}"

DESCRIPTION="broadcom firmware for b43 LP PHY and >=linux-3.2"
HOMEPAGE="http://linuxwireless.org/en/users/Drivers/b43"
SRC_URI="http://www.lwfinger.com/b43-firmware/${MY_P}.tar.bz2"
S="${WORKDIR}"

LICENSE="Broadcom"
SLOT="b43"
KEYWORDS="~amd64 ~ppc ~x86"
RESTRICT="binchecks bindist strip"

BDEPEND=">=net-wireless/b43-fwcutter-015"

src_compile() {
	mkdir ebuild-output || die
	b43-fwcutter -w ebuild-output ${MY_P}.wl_apsta.o || die
}

src_install() {
	insinto /lib/firmware
	doins -r ebuild-output/.
}
