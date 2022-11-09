# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1

DESCRIPTION="A shim layer for notebook traits and config"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/notebook_shim/
	https://pypi.org/project/notebook-shim/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	<dev-python/jupyter_server-3[${PYTHON_USEDEP}]
	>=dev-python/jupyter_server-1.8[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest-tornasync[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# Defining 'pytest_plugins' in a non-top-level conftest is no longer supported:
	mv notebook_shim/conftest.py . || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_tornasync.plugin
}
