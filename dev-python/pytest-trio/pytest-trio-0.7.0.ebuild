# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="This is a pytest plugin to help you test projects that use Trio"
HOMEPAGE="
	https://github.com/python-trio/pytest-trio
	https://pypi.org/project/pytest-trio/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	>=dev-python/async_generator-1.9[${PYTHON_USEDEP}]
	dev-python/outcome[${PYTHON_USEDEP}]
	>=dev-python/pytest-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/trio-0.15[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/hypothesis-3.64[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source \
	dev-python/attrs \
	dev-python/sphinx_rtd_theme \
	dev-python/sphinxcontrib-trio

python_prepare_all() {
	# Defining 'pytest_plugins' in a non-top-level conftest is no longer supported:
	mv pytest_trio/_tests/conftest.py conftest.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# disable autoloading pytest-asyncio in nested pytest calls
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# since we disabled autoloading, force loading pytest-trio
	local -x PYTEST_PLUGINS=pytest_trio.plugin
	epytest
}
