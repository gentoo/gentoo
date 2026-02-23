# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/narwhals-dev/narwhals
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Extremely lightweight compatibility layer between dataframe libraries"
HOMEPAGE="
	https://github.com/narwhals-dev/narwhals/
	https://pypi.org/project/narwhals/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	test? (
		>=dev-python/pandas-1.1.3[${PYTHON_USEDEP}]
		>=dev-python/pyarrow-13.0.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( hypothesis pytest-env )
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# segfaults
		# https://github.com/apache/arrow/issues/47252
		'tests/modern_polars/unpivot_test.py::test_unpivot[pyarrow]'
		# fragile to parallel merges that can cause non-atomic .dist-info
		# changes
		tests/system_info_test.py::test_get_sys_info
	)

	epytest --runslow --constructors="pandas,pandas[nullable],pandas[pyarrow],pyarrow"
}
