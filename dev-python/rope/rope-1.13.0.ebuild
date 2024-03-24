# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python refactoring library"
HOMEPAGE="
	https://pypi.org/project/rope/
	https://github.com/python-rope/rope/
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="doc"

RDEPEND="
	>=dev-python/pytoolconfig-1.2.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# our venv style confuses this comparison
	ropetest/contrib/autoimport/utilstest.py::test_get_package_source_typing
	ropetest/contrib/autoimport/utilstest.py::test_get_package_tuple_typing
	ropetest/contrib/autoimport/utilstest.py::test_get_package_tuple_compiled
	# TODO
	ropetest/contrib/autoimport/autoimporttest.py::TestQueryUsesIndexes::test_search_by_name_like_uses_index
	ropetest/contrib/autoimport/autoimporttest.py::TestQueryUsesIndexes::test_search_module_like_uses_index
)
