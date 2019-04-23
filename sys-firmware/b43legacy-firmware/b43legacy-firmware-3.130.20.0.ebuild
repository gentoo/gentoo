# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

: ${B43_FIRMWARE_SRC_OBJ:=${A}}

MY_P="broadcom-wl-${PV}"
DESCRIPTION="broadcom firmware for b43legacy/bcm43xx"
HOMEPAGE="http://linuxwireless.org/en/users/Drivers/b43"
SRC_URI="http://downloads.openwrt.org/sources/wl_apsta-${PV}.o"

RESTRICT="binchecks bindist strip"

LICENSE="Broadcom"
SLOT=0
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=""
DEPEND=">=net-wireless/b43-fwcutter-012"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}" || die
}

src_compile() {
	mkdir ebuild-output
	b43-fwcutter -w ebuild-output $(find -name ${B43_FIRMWARE_SRC_OBJ}) || die
}

src_install() {
	insinto /lib/firmware
	doins -r ebuild-output/*
}
