# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Easy to use fixtures to write regression tests"
HOMEPAGE="
	https://github.com/ESSS/pytest-regressions/
	https://pypi.org/project/pytest-regressions/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pytest-datadir[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/sphinx-rtd-theme

python_test() {
	local EPYTEST_DESELECT=()
	local EPYTEST_IGNORE=()
	if ! has_version "dev-python/matplotlib[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/test_image_regression.py::test_image_regression
		)
	fi
	if ! has_version "dev-python/numpy[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=(
			tests/test_ndarrays_regression.py
		)
	fi
	if ! has_version "dev-python/pandas[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/test_filenames.py::test_foo
			tests/test_filenames.py::TestClass::test_foo
			tests/test_filenames.py::TestClassWithIgnoredName::test_foo
		)
		EPYTEST_IGNORE+=(
			tests/test_dataframe_regression.py
			tests/test_num_regression.py
		)
	fi
	if ! has_version "dev-python/pillow[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/test_image_regression.py
		)
	fi

	epytest
}
