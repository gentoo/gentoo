# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"
inherit distutils-r1

DESCRIPTION="Qt-based console for Jupyter with support for rich media output"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

RDEPEND="
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	>=dev-python/jupyter_client-4.1.1[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
	dev-python/QtPy[${PYTHON_USEDEP},gui,printsupport,svg]
"
BDEPEND="
	test? (
		dev-python/QtPy[${PYTHON_USEDEP},svg,testlib]
	)
"
# required by the tests that are removed:
#		dev-python/flaky[${PYTHON_USEDEP}]
#		dev-python/pytest-qt[${PYTHON_USEDEP}]

PDEPEND="dev-python/ipython[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs/source
distutils_enable_tests pytest

python_test() {
	# TODO: these tests require virtx; however, running under virtx
	# causes pytest to segv on exit (even though tests pass)
	epytest --ignore qtconsole/tests/test_00_console_widget.py
}
