# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

MY_PN="${PN}2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="PostgreSQL database adapter for Python"
HOMEPAGE="https://www.psycopg.org https://pypi.org/project/psycopg2/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-3+"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-db/postgresql-8.1:*"
DEPEND="${RDEPEND}"
BDEPEND="
	test? ( >=dev-db/postgresql-8.1[server] )
"

python_prepare_all() {
	if use debug; then
		sed -i 's/^\(define=\)/\1PSYCOPG_DEBUG,/' setup.cfg || die
	fi

	distutils-r1_python_prepare_all
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
