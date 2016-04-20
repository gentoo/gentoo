# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit linux-info

DESCRIPTION="Microcode for V.Islands Radeon GPUs and APUs"
HOMEPAGE="https://people.freedesktop.org/~agd5f/radeon_ucode/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="radeon-ucode"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="legacy"

RDEPEND="legacy? ( !sys-firmware/radeon-ucode )
	!>sys-kernel/linux-firmware-20150812[-savedconfig]"

S=${WORKDIR}/radeon_ucode

AMDGPU_LEGACY_CIK="bonaire hawaii kabini kaveri mullins"

src_install() {
	local directory files legacyfiles
	if use legacy; then
		for directory in ${AMDGPU_LEGACY_CIK}; do
			legacyfiles+=( ${directory}/*.bin )
		done
		insinto /lib/firmware/radeon
		doins ${legacyfiles[@]}
	fi
	for directory in */; do
		if [[ ${AMDGPU_LEGACY_CIK} != *${directory%/}* ]]; then
			files+=( ${directory}/*.bin )
		fi
	done
	insinto /lib/firmware/amdgpu
	doins ${files[@]}
	FILES=( ${files[@]/*\//amdgpu/} ${legacyfiles[@]/*\//radeon/} )
}

pkg_postinst() {
	if linux_config_exists && linux_chkconfig_builtin DRM_AMDGPU; then
		if ! linux_chkconfig_present FIRMWARE_IN_KERNEL || \
			! [[ "$(linux_chkconfig_string EXTRA_FIRMWARE)" == *_rlc.bin* ]]; then
			ewarn "Your kernel has amdgpu DRM built-in but not the microcode."
			ewarn "For kernel modesetting to work, please set in kernel config"
			ewarn "CONFIG_FIRMWARE_IN_KERNEL=y"
			ewarn "CONFIG_EXTRA_FIRMWARE_DIR=\"/lib/firmware\""
			ewarn "CONFIG_EXTRA_FIRMWARE=\"${FILES[@]}\""
			ewarn "You may skip microcode files for which no hardware is installed."
			ewarn "More information at https://wiki.gentoo.org/wiki/AMDGPU#Firmware"
		fi
	fi
}
