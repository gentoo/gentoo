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
KEYWORDS="amd64 ~arm ~arm64 x86"
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
		dev-python/cffi[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/pyelftools[${PYTHON_USEDEP}]
	') )
"

python_test() {
	"${EPYTHON}" test/test_imagegen.py || die "test_imagegen.py failed with ${EPYTHON}"
	"${EPYTHON}" test/test_espsecure.py || die "test_espsecure.py failed with ${EPYTHON}"
	"${EPYTHON}" test/test_espefuse_host.py || die "test_espefuse_host.py failed with ${EPYTHON}"
	"${EPYTHON}" test/test_merge_bin.py || die "test_merge_bin.py failed with ${EPYTHON}"
	"${EPYTHON}" test/test_modules.py || die "test_modules.py failed with ${EPYTHON}"
	# test/test_esptool.py and test/test_espefuse.py need real hardware connected
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
