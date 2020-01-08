# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Utility to communicate with the ROM bootloader in Espressif ESP8266 and ESP32"
HOMEPAGE="https://github.com/espressif/esptool"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/ecdsa[${PYTHON_USEDEP}]
	dev-python/pyaes[${PYTHON_USEDEP}]
	>=dev-python/pyserial-2.5[${PYTHON_USEDEP}]"

RESTRICT="test" # Uses a device connected to the serial port

python_test() {
	${EPYTHON} test/test_esptool.py || die
}
