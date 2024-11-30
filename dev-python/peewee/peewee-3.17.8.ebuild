# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Small Python ORM"
HOMEPAGE="
	https://github.com/coleifer/peewee/
	https://pypi.org/project/peewee/
"
SRC_URI="
	https://github.com/coleifer/peewee/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="examples +native-extensions test"
RESTRICT="!test? ( test )"

DEPEND="
	native-extensions? ( dev-db/sqlite:3= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-db/postgresql
		dev-python/psycopg:0[${PYTHON_USEDEP}]
		sys-libs/timezone-data
	)
"

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme

src_prepare() {
	# disable test failing on postgres 16
	sed -e 's/test_timeout/_&/' -i tests/sqliteq.py || die

	default
}

src_compile() {
	if ! use native-extensions; then
		local -x NO_SQLITE=1
	fi

	distutils-r1_src_compile
}

src_test() {
	initdb -D "${T}"/pgsql || die
	pg_ctl -w -D "${T}"/pgsql start -o "-h '' -k '${T}'" || die
	createdb -h "${T}" peewee_test || die
	psql -h "${T}" peewee_test -c 'create extension hstore;' || die

	local -x PEEWEE_PSQL_HOST="${T}"
	distutils-r1_src_test

	pg_ctl -w -D "${T}"/pgsql stop || die
}

python_test() {
	"${EPYTHON}" runtests.py -v 2 || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && DOCS=( examples/ )
	distutils-r1_python_install_all
}
