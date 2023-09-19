# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="pytest plugin to run your tests in a specific order"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-order
	https://pypi.org/project/pytest-order/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/pytest-6.4.2[${PYTHON_USEDEP}]"

BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Appears to fail due to extra warning in pytest 7
	"tests/test_dependency.py::test_order_dependencies_no_auto_mark"
	"tests/test_dependency.py::test_order_dependencies_auto_mark"
	"tests/test_order_group_scope_dep.py::test_class_group_scope_module_scope"
	"tests/test_order_group_scope_named_dep.py::test_class_group_scope_module_scope"
	"tests/test_xdist_handling.py::test_xdist_ordering"
)

distutils_enable_tests pytest
distutils_enable_sphinx docs/source
