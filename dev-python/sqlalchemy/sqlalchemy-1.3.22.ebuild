# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )
PYTHON_REQ_USE="sqlite?"

inherit distutils-r1 optfeature

MY_PN="SQLAlchemy"
MY_P="${MY_PN}-${PV/_beta/b}"

DESCRIPTION="Python SQL toolkit and Object Relational Mapper"
HOMEPAGE="https://www.sqlalchemy.org/ https://pypi.org/project/SQLAlchemy/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples +sqlite test"

# Use pytest-xdist to speed up tests
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# Ported part of those commits to fix failing tests:
	# https://github.com/sqlalchemy/sqlalchemy/commit/c68f9fb87868c45fcadcc942ce4a35f10ff2f7ea
	# https://github.com/sqlalchemy/sqlalchemy/commit/a9b068ae564e5e775e312373088545b75aeaa1b0
	# https://github.com/sqlalchemy/sqlalchemy/commit/9e31fc74089cf565df5f275d22eb8ae5414d6e45
	"${FILESDIR}/sqlalchemy-1.3.20-pypy3.patch"
)

distutils_enable_tests pytest

python_test() {
	# Use all CPUs with pytest-xdist
	pytest -n auto -vv || die "Tests failed with ${EPYTHON}"
}

python_prepare_all() {
	# Disable tests hardcoding function call counts specific to Python versions.
	rm -r test/aaa_profiling || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "MySQL support" dev-python/mysqlclient dev-python/pymysql \
		dev-python/mysql-connector-python
	optfeature "mssql support" dev-python/pymssql
	optfeature "postgresql support" dev-python/psycopg:2
}
