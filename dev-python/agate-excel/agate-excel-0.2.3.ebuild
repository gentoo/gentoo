# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Adds read support for Excel files (xls and xlsx) to agate."
HOMEPAGE="https://github.com/wireservice/agate-excel https://pypi.org/project/agate-excel/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+xml"

# Other packages have BDEPEND="test? ( dev-python/agate-excel[xml] )"
AGATE_VERSION_DEP=">=dev-python/agate-1.5.0"
TEST_AGAINST_RDEPEND="xml? ( ${AGATE_VERSION_DEP}[xml,${PYTHON_USEDEP}] )"
RDEPEND="
	${AGATE_VERSION_DEP}[${PYTHON_USEDEP}]
	>=dev-python/openpyxl-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/xlrd-0.9.4[${PYTHON_USEDEP}]

	${TEST_AGAINST_RDEPEND}
"
BDEPEND="test? ( ${AGATE_VERSION_DEP}[xml,${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		tests/test_table_xlsx.py::TestXLSX::test_ambiguous_date
	)
	epytest ${deselect[@]/#/--deselect }
}
