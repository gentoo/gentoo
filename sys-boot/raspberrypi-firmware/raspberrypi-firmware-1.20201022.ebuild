# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mount-boot readme.gentoo-r1

DESCRIPTION="Raspberry Pi (all versions) bootloader and GPU firmware"
HOMEPAGE="https://github.com/raspberrypi/firmware"
LICENSE="GPL-2 raspberrypi-videocore-bin"
SLOT="0"

# Temporary safety measure to prevent ending up with a pair of
# sys-kernel/raspberrypi-image and sys-boot/raspberrypi-firmware
# none of which installed device tree files.
# Remove when the mentioned version and all older ones are deleted.
RDEPEND="!<=sys-kernel/raspberrypi-image-4.19.57_p20190709"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/raspberrypi/firmware"
	EGIT_CLONE_TYPE="shallow"
else
	SRC_URI="https://github.com/raspberrypi/firmware/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="-* ~arm ~arm64"
	S="${WORKDIR}/firmware-${PV}"
fi

RESTRICT="binchecks strip"

pkg_preinst() {
	if [ -z "${REPLACING_VERSIONS}" ] ; then
		local msg=""
		if [ -e "${D}"/boot/cmdline.txt -a -e /boot/cmdline.txt ] ; then
			msg+="/boot/cmdline.txt "
		fi
		if [ -e "${D}"/boot/config.txt -a -e /boot/config.txt ] ; then
			msg+="/boot/config.txt "
		fi
		if [ -n "${msg}" ] ; then
			msg="This package installs following files: ${msg}."
			msg="${msg} Please remove(backup) your copies durning install"
			msg="${msg} and merge settings afterwards."
			msg="${msg} Further updates will be CONFIG_PROTECTed."
			die "${msg}"
		fi
	fi
}

src_prepare() {
	default
	cp "${FILESDIR}"/${PN}-1.20201022-config.txt "${WORKDIR}" || die
	if use arm64; then
		# Force selection of the 64-bit kernel8.img to match our userland
		echo "arm_64bit=1" >> "${WORKDIR}"/${PN}-1.20201022-config.txt || die
	fi
}

src_install() {
	insinto /boot
	cd boot || die
	doins bootcode.bin fixup*.dat start*elf
	newins "${WORKDIR}"/${PN}-1.20201022-config.txt config.txt
	newins "${FILESDIR}"/${PN}-1.20201022-cmdline.txt cmdline.txt
	newenvd "${FILESDIR}"/${PN}-0_p20130711-envd 90${PN}
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}

DOC_CONTENTS="Please configure your ram setup by editing /boot/config.txt"
