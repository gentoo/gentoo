# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

DESCRIPTION="A JavaScript Object Signing and Encryption (JOSE) implementation in Python"
HOMEPAGE="https://github.com/mpdavis/python-jose https://pypi.org/project/python-jose/"
# pypi tarball lacks unit tests
SRC_URI="https://github.com/mpdavis/python-jose/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	>=dev-python/pycryptodome-3.3.1[${PYTHON_USEDEP}]
	dev-python/rsa[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -e 's|'\''pytest-runner'\'',\?||' -i setup.py || die
	sed -e '/addopts/d' -i setup.cfg || die
	sed -e 's:test_key_too_short:_&:' \
		-i tests/algorithms/test_EC.py || die
	distutils-r1_python_prepare_all
}
