# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Pure python ctypes wrapper for libsecp256k1"
HOMEPAGE="
	https://github.com/spesmilo/electrum-ecc/
	https://pypi.org/project/electrum-ecc/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# check ecc_fast.py for supported SOVERSIONS
RDEPEND="
	|| (
		dev-libs/libsecp256k1:0/5
		dev-libs/libsecp256k1:0/2
	)
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

export ELECTRUM_ECC_DONT_COMPILE=1

python_test() {
	cd tests || die
	eunittest
}
