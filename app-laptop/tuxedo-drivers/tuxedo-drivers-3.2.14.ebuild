# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CONFIG_CHECK="ACPI_WMI INPUT_SPARSEKMAP"

inherit linux-mod-r1

DESCRIPTION="Kernel Module for Tuxedo Keyboard"
HOMEPAGE="https://gitlab.com/tuxedocomputers/development/packages/tuxedo-drivers"
SRC_URI="https://gitlab.com/tuxedocomputers/development/packages/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( )

S="${WORKDIR}/${PN}-v${PV}"

src_compile() {
	local modlist=(
		clevo_acpi=tuxedo::src
		clevo_wmi=tuxedo::src
		uniwill_wmi=tuxedo::src
		tuxedo_keyboard=tuxedo::src
		tuxedo_io=tuxedo::src/tuxedo_io
	)
	local modargs=( KDIR=${KV_OUT_DIR} )

	linux-mod-r1_src_compile
}
