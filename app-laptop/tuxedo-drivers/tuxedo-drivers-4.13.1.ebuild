# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1 udev

DESCRIPTION="Kernel modules for TUXEDO laptops"
HOMEPAGE="https://gitlab.com/tuxedocomputers/development/packages/tuxedo-drivers"
SRC_URI="https://gitlab.com/tuxedocomputers/development/packages/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"

S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}"

PATCHES=( )

pkg_setup() {
	local CONFIG_CHECK="
		ACPI_WMI
		IIO
		INPUT_SPARSEKMAP
		LEDS_CLASS_MULTICOLOR
	"

	local ERROR_LEDS_CLASS_MULTICOLOR="CONFIG_LEDS_CLASS_MULTICOLOR: is required for keyboard backlight"

	local ERROR_ACPI_WMI="CONFIG_ACPI_WMI: is required for tuxedo-drivers"
	local ERROR_INPUT_SPARSEKMAP="CONFIG_INPUT_SPARSEKMAP: is required for tuxedo-drivers"
	local ERROR_IIOP="CONFIG_IIO: is required for tuxedo-drivers"

	linux-mod-r1_pkg_setup
}

src_compile() {
	local modlist=(
		clevo_acpi=tuxedo::src
		clevo_wmi=tuxedo::src
		gxtp7380=tuxedo::src/gxtp7380
		ite_8291=tuxedo::src/ite_8291
		ite_8291_lb=tuxedo::src/ite_8291_lb
		ite_8297=tuxedo::src/ite_8297
		ite_829x=tuxedo::src/ite_829x
		stk8321=tuxedo::src/stk8321
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
		tuxedo_tuxi_fan_control=tuxedo::src/tuxedo_tuxi
		tuxi_acpi=tuxedo::src/tuxedo_tuxi
		uniwill_wmi=tuxedo::src
	)
	local modargs=( KDIR=${KV_OUT_DIR} )

	linux-mod-r1_src_compile
}
src_install() {
	insinto /usr/lib/udev/hwdb.d
	doins *.hwdb
	udev_dorules *.rules
	linux-mod-r1_src_install
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst
	systemd-hwdb update --root="${ROOT}"
	udev_reload
}

pkg_postrm() {
	udev_reload
}
