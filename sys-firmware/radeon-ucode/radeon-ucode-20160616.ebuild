# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit linux-info

DESCRIPTION="IRQ microcode for r6xx/r7xx/Evergreen/N.Islands/S.Islands Radeon GPUs and APUs"
HOMEPAGE="https://people.freedesktop.org/~agd5f/radeon_ucode/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="radeon-ucode"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!sys-kernel/linux-firmware[-savedconfig]"

S=${WORKDIR}/radeon

src_install() {
	insinto /lib/firmware/radeon
	FILES=( *.bin )
	doins ${FILES[@]} || die "doins failed"
}

pkg_postinst() {
	if linux_config_exists && linux_chkconfig_builtin DRM_RADEON; then
		if ! linux_chkconfig_present FIRMWARE_IN_KERNEL || \
			! [[ "$(linux_chkconfig_string EXTRA_FIRMWARE)" == *_rlc.bin* ]]; then
			ewarn "Your kernel has radeon DRM built-in but not the IRQ microcode."
			ewarn "For kernel modesetting to work, please set in kernel config"
			ewarn "CONFIG_FIRMWARE_IN_KERNEL=y"
			ewarn "CONFIG_EXTRA_FIRMWARE_DIR=\"/lib/firmware\""
			ewarn "CONFIG_EXTRA_FIRMWARE=\"${FILES[@]/#/radeon/}\""
			ewarn "You may skip microcode files for which no hardware is installed."
			ewarn "More information at https://wiki.gentoo.org/wiki/Radeon#Firmware"
		fi
	fi
}
