# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit linux-info

RADEON_UCODE_LINUX_FIRMWARE="linux-firmware-20170113"

DESCRIPTION="IRQ microcode for r6xx/r7xx/Evergreen/N.Islands/S.Islands Radeon GPUs and APUs"
HOMEPAGE="https://people.freedesktop.org/~agd5f/radeon_ucode/"
SRC_URI="mirror://gentoo/${RADEON_UCODE_LINUX_FIRMWARE}.tar.xz"

LICENSE="radeon-ucode"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="!sys-kernel/linux-firmware[-savedconfig]"

S=${WORKDIR}/${RADEON_UCODE_LINUX_FIRMWARE}

src_unpack() {
	unpack ${A}
	mv linux-firmware-* ${RADEON_UCODE_LINUX_FIRMWARE} || die
}

src_install() {
	insinto /lib/firmware
	doins -r radeon
	FILES=( radeon/*.bin )
}

pkg_postinst() {
	if linux_config_exists && linux_chkconfig_builtin DRM_RADEON; then
		if ! linux_chkconfig_present FIRMWARE_IN_KERNEL || \
			! [[ "$(linux_chkconfig_string EXTRA_FIRMWARE)" == *_rlc.bin* ]]; then
			ewarn "Your kernel has radeon DRM built-in but not the IRQ microcode."
			ewarn "For kernel modesetting to work, please set in kernel config"
			ewarn "CONFIG_FIRMWARE_IN_KERNEL=y"
			ewarn "CONFIG_EXTRA_FIRMWARE_DIR=\"/lib/firmware\""
			ewarn "CONFIG_EXTRA_FIRMWARE=\"${FILES[@]}\""
			ewarn "You may skip microcode files for which no hardware is installed."
			ewarn "More information at https://wiki.gentoo.org/wiki/Radeon#Firmware"
		fi
	fi
}
