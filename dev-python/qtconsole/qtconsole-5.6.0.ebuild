# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi virtualx

DESCRIPTION="Qt-based console for Jupyter with support for rich media output"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/qtconsole/
	https://pypi.org/project/qtconsole/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"

RDEPEND="
	>=dev-python/ipykernel-4.1[${PYTHON_USEDEP}]
	dev-python/jupyter-core[${PYTHON_USEDEP}]
	>=dev-python/jupyter-client-4.1.1[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.2.2_p1[${PYTHON_USEDEP}]
	>=dev-python/QtPy-2.4.0[${PYTHON_USEDEP},gui,printsupport,svg]
"
BDEPEND="
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/pytest-qt[${PYTHON_USEDEP}]
		dev-python/QtPy[${PYTHON_USEDEP},svg,testlib]
	)
"

PDEPEND="
	dev-python/ipython[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs/source dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO; expects exact HTML, so perhaps fragile
		qtconsole/tests/test_jupyter_widget.py::TestJupyterWidget::test_other_output
	)
	local -x QT_API
	for QT_API in pyqt5 pyqt6 pyside2 pyside6; do
		if has_version "dev-python/QtPy[${QT_API}]"; then
			local -x PYTEST_QT_API=${QT_API}
			einfo "Testing with ${QT_API}"
			nonfatal epytest ||
				die "Tests failed with ${EPYTHON} / ${QT_API}"
		fi
	done
}
