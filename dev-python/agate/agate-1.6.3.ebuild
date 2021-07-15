# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="A Python data analysis library that is optimized for humans instead of machines"
HOMEPAGE="https://github.com/wireservice/agate https://pypi.org/project/agate/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+xml"

# Other packages have BDEPEND="test? ( dev-python/agate[xml] )"
LEATHER_VERSION_DEP=">=dev-python/leather-0.3.3-r2"
TEST_AGAINST_RDEPEND="xml? ( ${LEATHER_VERSION_DEP}[xml,${PYTHON_USEDEP}] )"
RDEPEND="
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/pytimeparse-1.1.5[${PYTHON_USEDEP}]
	>=dev-python/parsedatetime-2.1[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.0[${PYTHON_USEDEP}]
	>=dev-python/isodate-0.5.4[${PYTHON_USEDEP}]
	>=dev-python/pyicu-2.4.2[${PYTHON_USEDEP}]
	>=dev-python/python-slugify-1.2.1[${PYTHON_USEDEP}]
	${LEATHER_VERSION_DEP}[${PYTHON_USEDEP}]

	${TEST_AGAINST_RDEPEND}
"
BDEPEND="test? ( ${LEATHER_VERSION_DEP}[xml,${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# require specific locales
		tests/test_data_types.py::TestDate::test_cast_format_locale
		tests/test_data_types.py::TestDateTime::test_cast_format_locale
	)
	epytest ${deselect[@]/#/--deselect }
}
