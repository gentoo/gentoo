# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Extremely lightweight compatibility layer between dataframe libraries"
HOMEPAGE="
	https://github.com/narwhals-dev/narwhals/
	https://pypi.org/project/narwhals/
"
# https://github.com/narwhals-dev/narwhals/issues/2284
SRC_URI="
	https://github.com/narwhals-dev/narwhals/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pyarrow[${PYTHON_USEDEP}]
		dev-python/pytest-env[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest --runslow --constructors="pandas,pandas[pyarrow],pyarrow"
}
