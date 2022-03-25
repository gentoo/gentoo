# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Utility to communicate with the ROM bootloader in Espressif ESP8266 and ESP32"
HOMEPAGE="https://github.com/espressif/esptool"
SRC_URI="https://github.com/espressif/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/bitstring[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		>=dev-python/ecdsa-0.16.0[${PYTHON_USEDEP}]
		dev-python/pyserial[${PYTHON_USEDEP}]
		dev-python/reedsolomon[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/wheel[${PYTHON_USEDEP}]
	')
	test? ( $(python_gen_cond_dep '
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/pyelftools[${PYTHON_USEDEP}]
	') )
"

python_test() {
	"${EPYTHON}" test/test_imagegen.py || die "imagegen test failed with ${EPYTHON}"
	"${EPYTHON}" test/test_espsecure.py || die "espsecure test failed with ${EPYTHON}"
	"${EPYTHON}" test/test_espefuse_host.py || die "espefuse_host test failed with ${EPYTHON}"
	"${EPYTHON}" test/test_merge_bin.py || die "espefuse_host test failed with ${EPYTHON}"
	# test/test_esptool.py and test/test_espefuse.py need real hardware connected
}
