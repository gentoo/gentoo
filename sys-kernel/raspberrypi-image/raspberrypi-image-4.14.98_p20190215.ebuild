# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mount-boot

MY_PV="1.$(ver_cut 5)"

DESCRIPTION="Raspberry Pi (all versions) kernel and modules"
HOMEPAGE="https://github.com/raspberrypi/firmware"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="-* ~arm ~arm64"

RDEPEND="sys-boot/raspberrypi-firmware"

S="${WORKDIR}/firmware-${MY_PV}"

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	insinto /boot
	doins boot/*.img

	insinto /lib/modules
	doins -r modules/.
}
