# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
# py3 appears underdone,
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils flag-o-matic

MY_PN="SQLAlchemy"
MY_P="${MY_PN}-${PV/_}"

DESCRIPTION="Python SQL toolkit and Object Relational Mapper"
HOMEPAGE="http://www.sqlalchemy.org/ https://pypi.org/project/SQLAlchemy/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples mssql mysql postgres +sqlite test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	mssql? ( dev-python/pymssql )
	mysql? ( dev-python/mysql-python )
	postgres? ( >=dev-python/psycopg-2 )
	sqlite? (
		>=dev-db/sqlite-3.3.13 )"
DEPEND="${RDEPEND}
	test? (
		>=dev-db/sqlite-3.3.13
		>=dev-python/nose-0.10.4[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${PN}-0.7-logging.handlers.patch" )

python_prepare_all() {
	# Disable tests hardcoding function call counts specific to Python versions.
	rm -fr test/aaa_profiling
	distutils-r1_python_prepare_all
}

python_configure_all() {
	append-flags -fno-strict-aliasing
}

python_test() {
	"${PYTHON}" sqla_nose.py || die
}

python_install_all() {
	distutils-r1_python_install_all

	if use doc; then
		pushd doc > /dev/null
		rm -fr build
		dohtml -r [a-z]* _images _static
		popd > /dev/null
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
