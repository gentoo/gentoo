# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="JSON RPC 2.0 server library"
HOMEPAGE="
	https://github.com/python-lsp/python-lsp-jsonrpc/
	https://pypi.org/project/python-lsp-jsonrpc/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"

RDEPEND="
	>=dev-python/ujson-3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pycodestyle[${PYTHON_USEDEP}]
		dev-python/pyflakes[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x TZ=UTC
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts=
}
