# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=3
	KEYWORDS="amd64 arm arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="SQL abstraction library for the Qt5 framework"

SLOT=5/${QT5_PV} # bug 639140
IUSE="freetds mysql oci8 odbc postgres +sqlite"
REQUIRED_USE="
	|| ( freetds mysql oci8 odbc postgres sqlite )
"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
	freetds? ( dev-db/freetds )
	mysql? ( dev-db/mysql-connector-c:= )
	oci8? ( dev-db/oracle-instantclient:=[sdk] )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND="${DEPEND}"

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
		$(usev sqlite -system-sqlite)
	)

	use oci8 && myconf+=("-I${ORACLE_HOME}/include" "-L${ORACLE_HOME}/$(get_libdir)")

	qt5-build_src_configure
}
