# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="broadcom firmware for b43legacy/bcm43xx"
HOMEPAGE="http://linuxwireless.org/en/users/Drivers/b43"
SRC_URI="http://downloads.openwrt.org/sources/wl_apsta-${PV}.o"
S="${WORKDIR}"

LICENSE="Broadcom"
SLOT="0"
KEYWORDS="amd64 ppc x86"
RESTRICT="binchecks bindist strip"

BDEPEND=">=net-wireless/b43-fwcutter-012"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}/wl_apsta.o" || die
}

src_compile() {
	mkdir ebuild-output || die
	b43-fwcutter -w ebuild-output wl_apsta.o || die
}

src_install() {
	insinto /lib/firmware
	doins -r ebuild-output/.
}
