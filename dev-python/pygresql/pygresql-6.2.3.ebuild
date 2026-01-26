# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN="PyGreSQL"
POSTGRES_COMPAT=( 9.6 {10..18} )
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 postgres pypi

DESCRIPTION="A Python interface for the PostgreSQL database"
HOMEPAGE="
	https://pygresql.github.io/
	https://github.com/PyGreSQL/PyGreSQL/
	https://pypi.org/project/PyGreSQL/
"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		dev-db/postgresql[server]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.2-CFLAGS.patch
)

distutils_enable_tests unittest

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		postgres_pkg_setup
	fi
}

src_test() {
	local db="${T}/pgsql"
	initdb --username=portage -D "${db}" || die
	pg_ctl -w -D "${db}" start \
		-o "-h '127.0.0.1' -p 5432 -k '${T}'" || die
	psql -h "${T}" -U portage -d postgres \
		-c "ALTER ROLE portage WITH PASSWORD 'postgres';" || die
	createdb -h "${T}" -U portage test || die

	cat > tests/LOCAL_PyGreSQL.py <<-EOF || die
		dbhost = '${T}'
	EOF

	rm -rf pg || die
	distutils-r1_src_test

	pg_ctl -w -D "${db}" stop || die
}

python_install_all() {
	local DOCS=( docs/*.rst docs/community/* docs/contents/tutorial.rst )

	distutils-r1_python_install_all
}
