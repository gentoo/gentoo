# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517=setuptools
POSTGRES_COMPAT=( 9.6 {10..14} )
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 postgres

MY_P="PyGreSQL-${PV}"

DESCRIPTION="A Python interface for the PostgreSQL database"
HOMEPAGE="https://pygresql.org/"
SRC_URI="mirror://pypi/P/PyGreSQL/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.2-CFLAGS.patch
)

distutils_enable_tests unittest

src_test() {
	local db="${T}/pgsql"
	initdb --username=portage -D "${db}" || die
	pg_ctl -w -D "${db}" start \
		-o "-h '127.0.0.1' -p 5432 -k '${T}'" || die
	psql -h "${T}" -U portage -d postgres \
		-c "ALTER ROLE portage WITH PASSWORD 'postgres';" || die
	createdb -h "${T}" -U portage unittest || die

	cat > tests/LOCAL_PyGreSQL.py <<-EOF || die
		dbhost = '${T}'
	EOF

	distutils-r1_src_test

	pg_ctl -w -D "${db}" stop || die
}

python_install_all() {
	local DOCS=( docs/*.rst docs/community/* docs/contents/tutorial.rst )

	distutils-r1_python_install_all
}
