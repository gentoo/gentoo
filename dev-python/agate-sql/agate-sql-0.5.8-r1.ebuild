# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Adds SQL read/write support to agate."
HOMEPAGE="https://github.com/wireservice/agate-sql https://pypi.org/project/agate-sql/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/agate-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.0.8[${PYTHON_USEDEP}]
"
BDEPEND="test? ( dev-python/lxml[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# requires crate
	tests/test_agatesql.py::TestSQL::test_to_sql_create_statement_with_dialects
)
