# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="broadcom firmware for b43legacy/bcm43xx"
HOMEPAGE="https://wireless.docs.kernel.org/en/latest/en/users/drivers/b43.html"
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
