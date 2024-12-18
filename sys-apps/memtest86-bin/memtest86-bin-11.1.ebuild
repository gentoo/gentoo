# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mount-boot secureboot

DESCRIPTION="Stand alone memory testing software for x86 EFI hardware"
HOMEPAGE="http://www.memtest86.com/"
SRC_URI="https://www.memtest86.com/downloads/memtest86-usb.zip -> ${P}.zip"
S="${WORKDIR}"

LICENSE="PassMark-EULA"
SLOT=0
KEYWORDS="-* ~amd64"
RESTRICT="mirror bindist"

BDEPEND="
	app-arch/unzip
	sys-fs/fatcat
"

src_unpack() {
	default
	fatcat -O 1048576 -r /EFI/BOOT/BOOTX64.efi memtest86-usb.img > ${PN}.efi || die
}

src_install() {
	insinto /boot
	doins ${PN}.efi

	exeinto /etc/grub.d/
	newexe "${FILESDIR}"/${PN}-grub.d 39_memtest86-bin

	dodoc MemTest86_User_Guide_UEFI.pdf

	secureboot_auto_sign --in-place
}

pkg_postinst() {
	mount-boot_pkg_postinst

	if [ ! -e /sys/firmware/efi ]; then
		ewarn "WARNING: You appear to be booted in BIOS mode but ${PN} is an EFI-only tool."
	fi
}
