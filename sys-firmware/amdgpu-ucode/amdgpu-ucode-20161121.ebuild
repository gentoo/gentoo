# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit linux-info

AMDGPU_UCODE_LINUX_FIRMWARE="linux-firmware-20170113"

DESCRIPTION="Microcode for C.Islands/V.Islands/A.Islands Radeon GPUs and APUs"
HOMEPAGE="https://people.freedesktop.org/~agd5f/radeon_ucode/"
SRC_URI="mirror://gentoo/${AMDGPU_UCODE_LINUX_FIRMWARE}.tar.xz"

LICENSE="radeon-ucode"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="legacy"

RDEPEND="legacy? ( !sys-firmware/radeon-ucode )
	!>sys-kernel/linux-firmware-20150812[-savedconfig]"

S=${WORKDIR}/${AMDGPU_UCODE_LINUX_FIRMWARE}/amdgpu

AMDGPU_LEGACY_CIK="bonaire hainan hawaii kabini kaveri mullins oland pitcairn tahiti verde"

src_unpack() {
	unpack ${A}
	mv linux-firmware-* "${AMDGPU_UCODE_LINUX_FIRMWARE}" || die
}

src_install() {
	local chip files legacyfiles
	if use legacy; then
		pushd ../radeon || die
		for chip in ${AMDGPU_LEGACY_CIK}; do
			legacyfiles+=( ${chip}*.bin )
		done
		insinto /lib/firmware/radeon
		doins ${legacyfiles[@]}
		popd
	fi
	files=( *.bin )
	insinto /lib/firmware/amdgpu
	doins ${files[@]}
	FILES=( ${files[@]/#/amdgpu/} ${legacyfiles[@]/#/radeon/} )
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
