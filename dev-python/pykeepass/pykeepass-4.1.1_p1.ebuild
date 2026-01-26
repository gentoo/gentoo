# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python library to interact with keepass databases (supports KDBX3 and KDBX4)"
HOMEPAGE="
	https://github.com/libkeepass/pykeepass/
	https://pypi.org/project/pykeepass/
"
# no tests in sdist
SRC_URI="
	https://github.com/libkeepass/pykeepass/archive/refs/tags/v$(pypi_translate_version ${PV}).tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/argon2-cffi-18.1.0[${PYTHON_USEDEP}]
	>=dev-python/construct-2.10.53[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/pycryptodome-3.6.2[${PYTHON_USEDEP}]
	>=dev-python/pyotp-2.9.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests unittest

python_prepare() {
	sed -e 's|pycryptodomex|pycryptodome|' -i pyproject.toml || die
	sed -e 's|from Cryptodome|from Crypto|' -i pykeepass/kdbx_parsing/{common,twofish}.py || die
}

python_test() {
	eunittest tests.tests
}
