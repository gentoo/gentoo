# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 mount-boot

DESCRIPTION="Raspberry Pi (all versions) kernel and modules"
HOMEPAGE="https://github.com/raspberrypi/firmware"
LICENSE="GPL-2 raspberrypi-videocore-bin"
SLOT="0"
EGIT_REPO_URI="https://github.com/raspberrypi/firmware"
RESTRICT="binchecks strip"

src_install() {
	insinto /lib/modules
	doins -r modules/*
	insinto /boot
	newins boot/kernel.img kernel.img
	newins boot/kernel7.img kernel7.img
}
