# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="Black plugin for the Python LSP Server"
HOMEPAGE="
	https://github.com/python-lsp/python-lsp-black/
	https://pypi.org/project/python-lsp-black/
"
SRC_URI="
	https://github.com/python-lsp/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/python-lsp-server-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/black-23.11.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/tomli[${PYTHON_USEDEP}]
		' 3.10)
		!!<dev-python/python-lsp-black-2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
