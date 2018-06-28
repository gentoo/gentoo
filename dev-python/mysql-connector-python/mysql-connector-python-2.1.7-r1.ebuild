# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )
inherit distutils-r1

DESCRIPTION="Python client library for MariaDB/MySQL"
HOMEPAGE="https://dev.mysql.com/downloads/connector/python/"
SRC_URI="https://dev.mysql.com/get/Downloads/Connector-Python/${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="examples test"

# tests/mysqld.py does not like MariaDB version strings.
# See the regex MySQLServerBase._get_version.
DEPEND="test? ( dev-db/mysql[server(+)] )"

# Tests currently fail.
# mysql.connector.errors.DatabaseError: 1300 (HY000): Invalid utf8 character string: ''
RESTRICT="test"

DOCS=( README.txt CHANGES.txt docs/README_DOCS.txt )

python_test() {
	"${EPYTHON}" unittests.py --with-mysql="${EPREFIX%/}/usr" --unix-socket="${T}" --mysql-topdir="${T}"
}

python_install_all(){
	distutils-r1_python_install_all
	if use examples ; then
		dodoc -r examples
	fi
}
