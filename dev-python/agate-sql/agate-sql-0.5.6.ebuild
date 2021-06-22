# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Adds SQL read/write support to agate."
HOMEPAGE="https://github.com/wireservice/agate-sql https://pypi.org/project/agate-sql/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test +xml"
RESTRICT="!test? ( test )"

# Other packages have BDEPEND="test? ( dev-python/agate-sql[xml] )"
AGATE_VERSION_DEP=">=dev-python/agate-1.5.0"
TEST_AGAINST_RDEPEND="xml? ( ${AGATE_VERSION_DEP}[xml,${PYTHON_USEDEP}] )"
RDEPEND="
	${AGATE_VERSION_DEP}[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.0.8[${PYTHON_USEDEP}]

	${TEST_AGAINST_RDEPEND}
"
BDEPEND="test? ( ${AGATE_VERSION_DEP}[xml,${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_prepare_all() {
	local sed_args=(
		-e "/crate/d"
		-e "/nose/d"
		-e "/geojson/d"
		-e "/Sphinx/d"
		-e "/sphinx_rtd_theme/d"
	)

	sed "${sed_args[@]}" -i setup.py agate_sql.egg-info/requires.txt || die
	distutils-r1_python_prepare_all
}

python_test() {
	local pytest_args test_name xfails

	xfails=(
		tests/test_agatesql.py::TestSQL::test_to_sql_create_statement_with_dialects
		tests/test_agatesql.py::TestSQL::test_to_sql_create_statement_with_schema
	)

	for test_name in "${xfails[@]}"; do
		pytest_args+=(--deselect "${test_name}")
	done

	epytest "${pytest_args[@]}" || die
}
