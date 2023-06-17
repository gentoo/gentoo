# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A suite of utilities for converting to and working with CSV"
HOMEPAGE="
	https://github.com/wireservice/csvkit/
	https://pypi.org/project/csvkit/
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/agate-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/agate-excel-0.2.2[${PYTHON_USEDEP}]
	>=dev-python/agate-dbf-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/agate-sql-0.5.3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# fails depending on locale, let's not force en_US
		tests/test_utilities/test_csvstat.py::TestCSVStat::test_decimal_format
	)
	local -x LC_ALL=C.UTF-8
	epytest
}
