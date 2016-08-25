# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Firmware and scripts for controlling the Portapack from Sharebrained"
HOMEPAGE="https://github.com/sharebrained/portapack-hackrf/releases"
SRC_URI="https://github.com/sharebrained/portapack-hackrf/releases/download/${PV}/portapack-h1-firmware-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PDEPEND=">=net-wireless/hackrf-tools-2015.07.2-r1
	=app-mobilephone/dfu-util-0.7"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/hackrf
	newins portapack-h1-firmware.bin portapack-h1-firmware-${PV}.bin
	ln -s portapack-h1-firmware-${PV}.bin "${ED}/usr/share/hackrf/portapack-h1-firmware.bin"

	cat << EOF > switch_to_portapack
#!/bin/sh
printf "Hold down the HackRF's DFU button (the button closest to the antenna jack)\n"
printf "then plug the HackRF into a USB port on your computer.\n"
printf "After the HackRF is plugged in, you may release the DFU button.\n"
printf "Press any key to continue or ^c to abort\n"
read
dfu-util --device 1fc9:000c --download /usr/share/hackrf/hackrf_one_usb_ram.dfu --reset
sleep 2s
hackrf_spiflash -w /usr/share/hackrf/portapack-h1-firmware.bin
EOF
	dobin switch_to_portapack
	cat << EOF > switch_to_hackrf
#!/bin/sh
printf "Hold down the HackRF's DFU button (the button closest to the antenna jack)\n"
printf "then plug the HackRF into a USB port on your computer.\n"
printf "After the HackRF is plugged in, you may release the DFU button.\n"
printf "Press any key to continue or ^c to abort\n"
read
dfu-util --device 1fc9:000c --download /usr/share/hackrf/hackrf_one_usb_ram.dfu --reset
sleep 2s
hackrf_spiflash -w /usr/share/hackrf/hackrf_one_usb_rom_to_ram.bin
EOF
	dobin switch_to_hackrf
}
