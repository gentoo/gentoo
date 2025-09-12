# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="broadcom-wl-${PV}"

DESCRIPTION="broadcom firmware for b43 LP PHY and >=linux-3.2"
HOMEPAGE="https://wireless.docs.kernel.org/en/latest/en/users/drivers/b43.html"
SRC_URI="http://www.lwfinger.com/b43-firmware/${MY_P}.tar.bz2"
S="${WORKDIR}"

LICENSE="Broadcom"
SLOT="b43"
RESTRICT="binchecks bindist strip"

BDEPEND=">=net-wireless/b43-fwcutter-018"

src_compile() {
	mkdir ebuild-output || die
	b43-fwcutter -w ebuild-output ${MY_P}.wl_apsta.o || die
}

src_install() {
	insinto /lib/firmware
	doins -r ebuild-output/.
	ewarn "This version of the firmware has been reported as buggy, that's why it has no keywords."
	ewarn "No one can fix bugs in this binary firmware except broadcom, do not open bugs about instability"
	ewarn "See https://bugs.gentoo.org/541080 for some details"
}
