# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="broadcom-wl-${PV}"

DESCRIPTION="broadcom firmware for b43 LP PHY and >=linux-3.2"
HOMEPAGE="https://wireless.docs.kernel.org/en/latest/en/users/drivers/b43.html"
SRC_URI="http://www.lwfinger.com/b43-firmware/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="Broadcom"
SLOT="b43"
KEYWORDS="amd64 ~arm64 ppc x86"
RESTRICT="binchecks bindist strip"

BDEPEND=">=net-wireless/b43-fwcutter-015"

src_compile() {
	mkdir ebuild-output || die
	b43-fwcutter -w ebuild-output linux/wl_apsta.o || die
}

src_install() {
	insinto /lib/firmware
	doins -r ebuild-output/.
}
