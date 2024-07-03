# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Utility to communicate with the ROM bootloader in Espressif ESP8266 and ESP32"
HOMEPAGE="https://github.com/espressif/esptool"
SRC_URI="https://github.com/espressif/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/bitstring[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		>=dev-python/ecdsa-0.16.0[${PYTHON_USEDEP}]
		dev-python/intelhex[${PYTHON_USEDEP}]
		dev-python/pyserial[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/reedsolo[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/wheel[${PYTHON_USEDEP}]
	')
	test? ( $(python_gen_cond_dep '
		dev-python/cffi[${PYTHON_USEDEP}]
		dev-python/pyelftools[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	') )
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# test/test_esptool.py and test/test_espefuse.py need real hardware connected
	test/test_esptool.py
	test/test_espefuse.py
)

src_prepare() {
	default

	# test_espsecure_hsm.py needs setup of a "Soft HSM" or real hardware. remove.
	rm test/test_espsecure_hsm.py || die
}

pkg_postinst() {
	if ver_test ${REPLACING_VERSIONS} -lt 4; then
		ewarn "${P} - new 4.x release with breaking changes:"
		ewarn "  - Public API has been defined by limiting access to internals that have been refactored into multiple source files"
		ewarn "  - If active security features are detected, the default behavior changes to prevent unintentional bricking"
		ewarn "  - Flash parameters in an image header can now be changed only when no SHA256 digest is appended"
		ewarn "  - The ESP8684 alias has been removed, ESP32-C2 has to be used"
		ewarn "  - Megabit flash sizes have been deprecated, use megabyte units from now on"
	fi
}
