# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Utility to communicate with the ROM bootloader in Espressif ESP8266 and ESP32"
HOMEPAGE="https://github.com/espressif/esptool"
SRC_URI="https://github.com/espressif/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="
	dev-python/ecdsa[${PYTHON_USEDEP}]
	dev-python/pyaes[${PYTHON_USEDEP}]
	>=dev-python/pyserial-3.0[${PYTHON_USEDEP}]
"

DEPEND="
	test? ( ${RDEPEND}
		dev-python/pyelftools[${PYTHON_USEDEP}]
	)
"

python_test() {
	${EPYTHON} test/test_imagegen.py || die "imagegen test failed with ${EPYTHON}"
	${EPYTHON} test/test_espsecure.py || die "espsecure test failed with ${EPYTHON}"
}
