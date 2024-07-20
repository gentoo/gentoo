# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN="psycopg2"
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="PostgreSQL database adapter for Python"
HOMEPAGE="
	https://www.psycopg.org/
	https://github.com/psycopg/psycopg2/
	https://pypi.org/project/psycopg2/
"

LICENSE="LGPL-3+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-db/postgresql-8.1:*"
DEPEND="${RDEPEND}"
BDEPEND="
	test? ( >=dev-db/postgresql-8.1[server] )
"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# fix for py3.13
	sed -e 's:_PyInterpreterState_Get:PyInterpreterState_Get:' \
		-i psycopg/utils.c || die
	# broken by different encoding of IPv4-mapped addresses
	sed -e 's:test_\(cidr\|inet\)_adapt:_&:' \
		-i tests/test_ipaddress.py || die

	if use debug; then
		sed -i 's/^\(define=\)/\1PSYCOPG_DEBUG,/' setup.cfg || die
	fi
}

src_test() {
	initdb -D "${T}"/pgsql || die
	# TODO: random port
	pg_ctl -w -D "${T}"/pgsql start \
		-o "-h '' -k '${T}'" || die
	createdb -h "${T}" psycopg2_test || die

	local -x PSYCOPG2_TESTDB_HOST="${T}"
	distutils-r1_src_test

	pg_ctl -w -D "${T}"/pgsql stop || die
}

python_test() {
	"${EPYTHON}" -c "
import tests
tests.unittest.main(defaultTest='tests.test_suite')
" --verbose || die "Tests fail with ${EPYTHON}"
}
