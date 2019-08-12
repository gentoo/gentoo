# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1

DESCRIPTION="Firmware and research tools for nRF24LU1+ based USB dongles and breakout boards"
HOMEPAGE="https://www.mousejack.com/"
COMMIT="02b84d1c4e59c0fb98263c83b2e7c7f9863a3b93"
SRC_URI="https://github.com/BastilleResearch/nrf-research-firmware/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/nrf-research-firmware-${COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DEPEND="dev-embedded/sdcc[device-lib,mcs51,sdbinutils]"
RDEPEND="${DEPEND}
		${PYTHON_DEPS}
		dev-python/pyusb[${PYTHON_USEDEP}]"

src_prepare() {
	mv tools/lib tools/nrf24 || die
	for file in tools/nrf24-*; do
		sed -i 's#from lib#from nrf24#' ${file} || die
	done
	default
}
src_install() {
	insinto /usr/share/${PN}
	doins bin/dongle.{bin,formatted.bin,formatted.ihx}

	python_domodule tools/nrf24
	python_doscript tools/nrf24-*

	python_scriptinto /usr/share/${PN}/prog
	python_doscript prog/usb-flasher/usb-flash.py
	python_doscript prog/usb-flasher/logitech-usb-flash.py
	python_doscript prog/usb-flasher/unifying.py

	dosbin "${FILESDIR}/mousejack"
}
