# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="A JavaScript Object Signing and Encryption (JOSE) implementation in Python"
HOMEPAGE="https://github.com/mpdavis/python-jose https://pypi.org/project/python-jose/"
# pypi tarball lacks unit tests
SRC_URI="https://github.com/mpdavis/python-jose/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	>=dev-python/pycryptodome-3.3.1[${PYTHON_USEDEP}]
	dev-python/rsa[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs

python_prepare_all() {
	sed -e '/pytest-runner/d' \
		-e '/ecdsa/s:<0.15::' \
		-i setup.py || die
	sed -e '/addopts/d' -i setup.cfg || die
	sed -e 's/sphinxcontrib.napoleon/sphinx.ext.napoleon/' -i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	local deselect=(
		tests/algorithms/test_EC.py::TestECAlgorithm::test_key_too_short
	)
	epytest ${deselect[@]/#/--deselect }
}
