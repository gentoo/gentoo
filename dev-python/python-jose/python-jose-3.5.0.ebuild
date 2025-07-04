# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="A JavaScript Object Signing and Encryption (JOSE) implementation in Python"
HOMEPAGE="
	https://github.com/mpdavis/python-jose/
	https://pypi.org/project/python-jose/
"
# pypi tarball lacks unit tests
SRC_URI="
	https://github.com/mpdavis/python-jose/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"

# TODO: require only one crypto backend?
RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/pycryptodome-3.3.1[${PYTHON_USEDEP}]
	dev-python/rsa[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs

python_prepare_all() {
	distutils-r1_python_prepare_all

	# unpin dependencies
	sed -i -e 's:, <[0-9.]*::' setup.cfg || die
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts=
}
