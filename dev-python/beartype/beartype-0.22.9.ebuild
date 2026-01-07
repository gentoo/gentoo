# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/beartype/beartype
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Unbearably fast runtime type checking in pure Python"
HOMEPAGE="
	https://pypi.org/project/beartype/
	https://github.com/beartype/beartype/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

BDEPEND="
	test? (
		dev-python/click[${PYTHON_USEDEP}]
		>=dev-python/docutils-0.22[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/redis[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/xarray[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fragile performance test
	beartype_test/a00_unit/a70_decor/test_decorwrapper.py::test_wrapper_fail_obj_large
	# test for building docs, apparently broken too
	beartype_test/a90_func/z90_lib/a00_sphinx
	# poetry, also broken
	beartype_test/a90_func/a50_external/test_poetry.py
	# broken
	beartype_test/a90_func/a90_pep/test_pep561_static.py::test_pep561_mypy
)
