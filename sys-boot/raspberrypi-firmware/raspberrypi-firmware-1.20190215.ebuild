# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mount-boot readme.gentoo-r1

DESCRIPTION="Raspberry Pi (all versions) bootloader and GPU firmware"
HOMEPAGE="https://github.com/raspberrypi/firmware"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="-* ~arm ~arm64"

S="${WORKDIR}/firmware-${PV}"

QA_PREBUILT="boot/*.elf"

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	insinto /boot
	doins boot/*.{bin,dat,dtb,elf} "${FILESDIR}"/{cmdline,config}.txt

	newenvd - 99raspberrypi-firmware <<- _EOF_
		CONFIG_PROTECT="/boot/config.txt /boot/cmdline.txt"
	_EOF_

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
