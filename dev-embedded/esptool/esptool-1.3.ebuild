# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="A utility to communicate with the ROM bootloader in Espressif ESP8266"
HOMEPAGE="https://github.com/espressif/esptool"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/pyserial[${PYTHON_USEDEP}]"

RESTRICT="test" # Uses a device connected to the serial port

python_test() {
	${EPYTHON} test/test_esptool.py || die
}
