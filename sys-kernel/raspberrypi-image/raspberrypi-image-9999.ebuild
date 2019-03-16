# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 mount-boot

DESCRIPTION="Raspberry Pi (all versions) kernel and modules"
HOMEPAGE="https://github.com/raspberrypi/firmware"
EGIT_REPO_URI="https://github.com/raspberrypi/firmware"

LICENSE="GPL-2 BSD"
SLOT="0"

RDEPEND="sys-boot/raspberrypi-firmware"

S="${WORKDIR}/raspberrypi-image-${PV}"

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
