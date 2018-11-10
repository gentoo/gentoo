# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Custom firmware for the HackRF SDR + PortaPack H1 addon"
HOMEPAGE="https://github.com/furrtek/portapack-havoc/wiki"
COMMIT="609235b19f55d0bf278c0e7c4b9f9b6b15136247"
SRC_URI="https://github.com/furrtek/portapack-havoc/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

PDEPEND=">=net-wireless/hackrf-tools-2015.07.2-r1
	>=app-mobilephone/dfu-util-0.7"

src_configure() {
	true
}

src_compile() {
	true
}

src_install() {
	insinto /usr/share/hackrf
	newins firmware/portapack-h1-havoc.bin portapack-h1-havoc-${PV}.bin
	ln -s portapack-h1-havoc-${PV}.bin "${ED}/usr/share/hackrf/portapack-h1-havoc.bin"

	cat << EOF > switch_to_havoc
#!/bin/sh
printf "Hold down the HackRF's DFU button (the button closest to the antenna jack)\n"
printf "then plug the HackRF into a USB port on your computer.\n"
printf "After the HackRF is plugged in, you may release the DFU button.\n"
printf "Press any key to continue or ^c to abort\n"
read
dfu-util --device 1fc9:000c --download /usr/share/hackrf/hackrf_one_usb_ram.dfu --reset
sleep 2s
hackrf_spiflash -w /usr/share/hackrf/portapack-h1-havoc.bin
EOF
	dobin switch_to_havoc
}
