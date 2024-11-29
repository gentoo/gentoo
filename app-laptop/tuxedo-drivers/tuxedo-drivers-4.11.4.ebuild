# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CONFIG_CHECK="ACPI_WMI INPUT_SPARSEKMAP"

inherit linux-mod-r1

DESCRIPTION="Kernel modules for TUXEDO laptops"
HOMEPAGE="https://gitlab.com/tuxedocomputers/development/packages/tuxedo-drivers"
SRC_URI="https://gitlab.com/tuxedocomputers/development/packages/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"

S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( )

src_compile() {
	local modlist=(
		clevo_acpi=tuxedo::src
		clevo_wmi=tuxedo::src
		ite_8291=tuxedo::src/ite_8291
		ite_8291_lb=tuxedo::src/ite_8291_lb
		ite_8297=tuxedo::src/ite_8297
		ite_829x=tuxedo::src/ite_829x
		tuxedo_compatibility_check=tuxedo::src/tuxedo_compatibility_check
		tuxedo_io=tuxedo::src/tuxedo_io
		tuxedo_keyboard=tuxedo::src
		tuxedo_nb02_nvidia_power_ctrl=tuxedo::src/tuxedo_nb02_nvidia_power_ctrl
		tuxedo_nb04_kbd_backlight=tuxedo::src/tuxedo_nb04
		tuxedo_nb04_keyboard=tuxedo::src/tuxedo_nb04
		tuxedo_nb04_power_profiles=tuxedo::src/tuxedo_nb04
		tuxedo_nb04_sensors=tuxedo::src/tuxedo_nb04
		tuxedo_nb04_wmi_ab=tuxedo::src/tuxedo_nb04
		tuxedo_nb04_wmi_bs=tuxedo::src/tuxedo_nb04
		tuxedo_nb05_ec=tuxedo::src/tuxedo_nb05
		tuxedo_nb05_fan_control=tuxedo::src/tuxedo_nb05
		tuxedo_nb05_kbd_backlight=tuxedo::src/tuxedo_nb05
		tuxedo_nb05_keyboard=tuxedo::src/tuxedo_nb05
		tuxedo_nb05_power_profiles=tuxedo::src/tuxedo_nb05
		tuxedo_nb05_sensors=tuxedo::src/tuxedo_nb05
		uniwill_wmi=tuxedo::src
	)
	local modargs=( KDIR=${KV_OUT_DIR} )

	linux-mod-r1_src_compile
}
