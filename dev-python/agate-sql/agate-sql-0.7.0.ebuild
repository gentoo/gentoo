# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Adds SQL read/write support to agate"
HOMEPAGE="
	https://github.com/wireservice/agate-sql/
	https://pypi.org/project/agate-sql/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/agate-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.4[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# requires crate
	tests/test_agatesql.py::TestSQL::test_to_sql_create_statement_with_dialects
)
