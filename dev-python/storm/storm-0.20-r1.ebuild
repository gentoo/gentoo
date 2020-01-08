# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1
PYTHON_REQ_USE="sqlite?"

inherit distutils-r1 flag-o-matic

DESCRIPTION="An object-relational mapper for Python developed at Canonical"
HOMEPAGE="https://storm.canonical.com/ https://pypi.org/project/storm/"
SRC_URI="https://launchpad.net/storm/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres sqlite test"
RESTRICT="!test? ( test )"

RDEPEND="mysql? ( dev-python/mysql-python[${PYTHON_USEDEP}] )
	postgres? ( =dev-python/psycopg-2*[${PYTHON_USEDEP}] )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/fixtures[${PYTHON_USEDEP}] )"

DOCS="tests/tutorial.txt"

pkg_setup() {
	append-cflags -fno-strict-aliasing
	python-single-r1_pkg_setup
}

python_prepare_all() {
	sed -e "s:find_packages():find_packages(exclude=['tests','tests.*']):" \
		-i setup.py || die

	# delete rogue errors in setting exceptions
	sed -e '/module_exception is not None:/d' \
		-e '/module_exception.__bases__ += (exception,)/d' \
		-i storm/exceptions.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	if use mysql; then
		elog "To run the MySQL-tests, you need:"
		elog "  - a running mysql-server"
		elog "  - an already existing database 'db'"
		elog "  - a user 'user' with full permissions on that database"
		elog "  - and an environment variable STORM_MYSQL_URI=\"mysql://user:password@host:1234/db\""
	fi
	if use postgres; then
		elog "To run the PostgreSQL-tests, you need:"
		elog "  - a running postgresql-server"
		elog "  - an already existing database 'db'"
		elog "  - a user 'user' with full permissions on that database"
		elog "  - and an environment variable STORM_POSTGRES_URI=\"postgres://user:password@host:1234/db\""
	fi

	# Some tests require a server instance which is absent
	"${PYTHON}" test --verbose || die
}
