# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mount-boot readme.gentoo-r1

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/raspberrypi/firmware"
	EGIT_CLONE_TYPE="shallow"
else
	SRC_URI="https://github.com/raspberrypi/firmware/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="-* arm arm64"
	S="${WORKDIR}/firmware-${PV}"
fi

DESCRIPTION="Raspberry Pi (all versions) bootloader and GPU firmware"
HOMEPAGE="https://github.com/raspberrypi/firmware"

LICENSE="GPL-2 raspberrypi-videocore-bin"
SLOT="0"
RESTRICT="binchecks strip"

DOC_CONTENTS="Please configure your ram setup by editing /boot/config.txt"

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

pkg_preinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		local msg=""

		if [[ -e "${ED}"/boot/cmdline.txt ]] && [[ -e /boot/cmdline.txt ]] ; then
			msg+="/boot/cmdline.txt "
		fi

		if [[ -e "${ED}"/boot/config.txt ]] && [[ -e /boot/config.txt ]] ; then
			msg+="/boot/config.txt "
		fi

		if [[ -n "${msg}" ]] ; then
			msg="This package installs following files: ${msg}."
			msg="${msg} Please remove (backup) your copies during install"
			msg="${msg} and merge settings afterwards."
			msg="${msg} Further updates will be CONFIG_PROTECTed."
			die "${msg}"
		fi
	fi
}

pkg_postinst() {
	readme.gentoo_print_elog
}
