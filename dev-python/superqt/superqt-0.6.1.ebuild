# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi virtualx

DESCRIPTION="Missing widgets and components for PyQt/PySide"
HOMEPAGE="
	https://github.com/pyapp-kit/superqt
	https://pypi.org/project/superqt/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/QtPy-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.7.4.3[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest-qt[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	# pint and pyconify not packaged
	tests/test_quantity.py
)

EPYTEST_DESELECT=(
	# fails in the sandbox, but works outside of it
	tests/test_eliding_label.py::test_wrapped_eliding_label
)

distutils_enable_tests pytest

python_test() {
	virtx distutils-r1_python_test
}
