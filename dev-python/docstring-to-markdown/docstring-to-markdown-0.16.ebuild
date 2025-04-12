# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1

DESCRIPTION="On the fly conversion of Python docstrings to markdown"
HOMEPAGE="
	https://github.com/python-lsp/docstring-to-markdown/
	https://pypi.org/project/docstring-to-markdown/
"
SRC_URI="
	https://github.com/python-lsp/docstring-to-markdown/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"

RDEPEND="
	>=dev-python/importlib-metadata-3.6[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.6[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts=
}
