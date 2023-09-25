# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Qt-based console for Jupyter with support for rich media output"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/qtconsole/
	https://pypi.org/project/qtconsole/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong x86"

RDEPEND="
	>=dev-python/ipykernel-4.1[${PYTHON_USEDEP}]
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	dev-python/jupyter-core[${PYTHON_USEDEP}]
	>=dev-python/jupyter-client-4.1.1[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-17.1[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.2.2_p1[${PYTHON_USEDEP}]
	>=dev-python/QtPy-2.0.1[${PYTHON_USEDEP},gui,printsupport,svg]
"
BDEPEND="
	test? (
		dev-python/QtPy[${PYTHON_USEDEP},svg,testlib]
	)
"
# required by the tests that are removed:
#		dev-python/flaky[${PYTHON_USEDEP}]
#		dev-python/pytest-qt[${PYTHON_USEDEP}]

PDEPEND="
	dev-python/ipython[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs/source dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

python_test() {
	# TODO: these tests require virtx; however, running under virtx
	# causes pytest to segv on exit (even though tests pass)
	local EPYTEST_IGNORE=(
		qtconsole/tests/test_00_console_widget.py
		qtconsole/tests/test_jupyter_widget.py
	)
	local -x QT_API
	for QT_API in pyqt5 pyqt6 pyside2 pyside6; do
		if has_version "dev-python/QtPy[${QT_API}]"; then
			local -x PYTEST_QT_API=${QT_API}
			einfo "Testing with ${QT_API}"
			epytest
		fi
	done
}
