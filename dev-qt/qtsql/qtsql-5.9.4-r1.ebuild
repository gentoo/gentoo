# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="SQL abstraction library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd"
fi

IUSE="freetds mysql oci8 odbc postgres +sqlite"

REQUIRED_USE="
	|| ( freetds mysql oci8 odbc postgres sqlite )
"

DEPEND="
	~dev-qt/qtcore-${PV}
	freetds? ( dev-db/freetds )
	mysql? ( virtual/libmysqlclient:= )
	oci8? ( dev-db/oracle-instantclient-basic )
	odbc? ( || ( dev-db/unixODBC dev-db/libiodbc ) )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( >=dev-db/sqlite-3.8.10.2:3 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-mariadb-10.2.patch"
	# See also: https://codereview.qt-project.org/#/c/206850/
)

QT5_TARGET_SUBDIRS=(
	src/sql
	src/plugins/sqldrivers
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:sql
)

src_configure() {
	local myconf=(
		$(qt_use freetds  sql-tds    plugin)
		$(qt_use mysql    sql-mysql  plugin)
		$(qt_use oci8     sql-oci    plugin)
		$(qt_use odbc     sql-odbc   plugin)
		$(qt_use postgres sql-psql   plugin)
		$(qt_use sqlite   sql-sqlite plugin)
		$(usex sqlite -system-sqlite '')
	)

	use mysql && myconf+=("-I${EPREFIX}/usr/include/mysql" "-L${EPREFIX}/usr/$(get_libdir)/mysql")
	use oci8 && myconf+=("-I${ORACLE_HOME}/include" "-L${ORACLE_HOME}/$(get_libdir)")
	use odbc && myconf+=("-I${EPREFIX}/usr/include/iodbc")
	use postgres && myconf+=("-I${EPREFIX}/usr/include/postgresql/pgsql")

	qt5-build_src_configure
}
