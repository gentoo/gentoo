# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Utility to communicate with the ROM bootloader in Espressif ESP8266 and ESP32"
HOMEPAGE="https://github.com/espressif/esptool"
SRC_URI="https://github.com/espressif/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/ecdsa[${PYTHON_MULTI_USEDEP}]
		dev-python/pyaes[${PYTHON_MULTI_USEDEP}]
		>=dev-python/pyserial-3.0[${PYTHON_MULTI_USEDEP}]
	')
"
BDEPEND="
	test? ( $(python_gen_cond_dep 'dev-python/pyelftools[${PYTHON_MULTI_USEDEP}]') )
"

src_prepare() {
	rm -rf pyaes/ ecdsa/ || die "unable to remove bundled modules"
	default
}

python_test() {
	${EPYTHON} test/test_imagegen.py || die "imagegen test failed with ${EPYTHON}"
	${EPYTHON} test/test_espsecure.py || die "espsecure test failed with ${EPYTHON}"
}
