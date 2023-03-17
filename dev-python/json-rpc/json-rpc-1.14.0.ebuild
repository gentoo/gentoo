# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="JSON-RPC transport implementation for python"
HOMEPAGE="
	https://github.com/pavlov99/json-rpc/
	https://pypi.org/project/json-rpc/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/flask[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	# bundled, sigh.
	rm jsonrpc/six.py || die
	sed -i -e 's:from . import six:import six:' jsonrpc/*.py || die
}
