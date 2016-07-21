# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="tools for communicating with HackRF SDR platform"
HOMEPAGE="http://greatscottgadgets.com/hackrf/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/mossmann/hackrf.git"
	inherit git-2
	KEYWORDS=""
	EGIT_SOURCEDIR="${WORKDIR}/hackrf"
	S="${WORKDIR}/hackrf/host/hackrf-tools"
else
	S="${WORKDIR}/hackrf-${PV}/host/hackrf-tools"
	SRC_URI="https://github.com/mossmann/hackrf/releases/download/v${PV}/hackrf-${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~ppc ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="=net-libs/libhackrf-${PV}:="
RDEPEND="${DEPEND}"

src_install() {
	cmake-utils_src_install
	if [[ ${PV} != "9999" ]] ; then
		insinto /usr/share/hackrf
		newins "${WORKDIR}/hackrf-${PV}/firmware-bin/hackrf_jawbreaker_usb_rom_to_ram.bin" hackrf_jawbreaker_usb_rom_to_ram-${PV}.bin
		newins "${WORKDIR}/hackrf-${PV}/firmware-bin/hackrf_jawbreaker_usb_ram.dfu" hackrf_jawbreaker_usb_ram-${PV}.dfu
		newins "${WORKDIR}/hackrf-${PV}/firmware-bin/hackrf_one_usb_rom_to_ram.bin" hackrf_one_usb_rom_to_ram-${PV}.bin
		newins "${WORKDIR}/hackrf-${PV}/firmware-bin/hackrf_one_usb_ram.dfu" hackrf_one_usb_ram-${PV}.dfu
		newins "${WORKDIR}/hackrf-${PV}/firmware/cpld/sgpio_if/default.xsvf" hackrf_cpld_default-${PV}.xsvf
		ln -s hackrf_one_usb_rom_to_ram-${PV}.bin "${ED}/usr/share/hackrf/hackrf_one_usb_rom_to_ram.bin"
		ln -s hackrf_one_usb_ram-${PV}.dfu "${ED}/usr/share/hackrf/hackrf_one_usb_ram.dfu"
	else
		ewarn "The compiled firmware files are only available in the versioned releases, you are on your own for this."
	fi
}
