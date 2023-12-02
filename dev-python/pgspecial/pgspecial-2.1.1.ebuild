# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python implementation of PostgreSQL meta commands"
HOMEPAGE="
	https://github.com/dbcli/pgspecial/
	https://pypi.org/project/pgspecial/
"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="
	>=dev-python/click-4.1[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/psycopg-3.0.10:0[${PYTHON_USEDEP}]
	>=dev-python/sqlparse-0.1.19[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-db/postgresql-8.1[server]
	)
"

distutils_enable_tests pytest

DOCS=( License.txt README.rst changelog.rst  )

EPYTEST_DESELECT=(
	# assumes a very specific locale
	tests/test_specials.py::test_slash_l
	tests/test_specials.py::test_slash_l_pattern
	# change in postgres? *shrug*
	tests/test_specials.py::test_slash_d_view_verbose
)

src_test() {
	local db=${T}/pgsql

	initdb --username=postgres -D "${db}" || die
	# TODO: random port
	pg_ctl -w -D "${db}" start \
		-o "-h '127.0.0.1' -p 5432 -k '${T}'" || die
	psql -h "${T}" -U postgres -d postgres \
		-c "ALTER ROLE postgres WITH PASSWORD 'postgres';" || die
	createdb -h "${T}" -U postgres _test_db || die

	distutils-r1_src_test

	pg_ctl -w -D "${db}" stop || die
}
