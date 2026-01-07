# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="SOCI - The C++ Database Access Library"
HOMEPAGE="https://sourceforge.net/projects/soci/"
SRC_URI="https://sourceforge.net/projects/soci/files/soci/${P}/${P}.tar.gz/download -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="mariadb mysql odbc oracle postgres sqlite test"
REQUIRED_USE="?? ( mysql mariadb )"
RESTRICT="!test? ( test )"

CMAKE_SKIP_TESTS=(
	soci_odbc_test_mssql
	soci_odbc_test_mssql_static
	soci_odbc_test_mysql
	soci_odbc_test_mysql_static
	soci_odbc_test_postgresql
	soci_odbc_test_postgresql_static
	soci_postgresql_test
	soci_postgresql_test_static
	soci_mysql_test
	soci_mysql_test_static
)

RDEPEND="
	>=dev-libs/boost-1.85.0-r1:=
	mysql? ( dev-db/mysql-connector-c:0= )
	mariadb? ( dev-db/mariadb-connector-c:0= )
	odbc? ( dev-db/unixODBC )
	oracle? ( dev-db/oracle-instantclient:=[sdk] )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( dev-db/sqlite )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	cmake_src_prepare
	cp "${FILESDIR}/FindMySQL.cmake" "cmake/find_modules" || die
}

src_configure() {
	local mysql_backend_driver="$(usex mysql 'mysqlclient' "$(usev mariadb 'libmariadb')")"
	local mysql_backend_cmake_args=(
	)
	if [[ -n "$mysql_backend_driver" ]]; then
		local mysql_backend_include="$($(tc-getPKG_CONFIG) --cflags-only-I $mysql_backend_driver)"
		local mysql_backend_libs="$($(tc-getPKG_CONFIG) --libs $mysql_backend_driver)"
		if [[ -z "$mysql_backend_include" ]] || [[ -z "$mysql_backend_libs" ]]; then
			die
		fi
		mysql_backend_cmake_args=(
			-DMySQL_INCLUDE_DIRS="$(echo "$mysql_backend_include" | sed -e 's/-I//')"
			-DMySQL_LIBRARIES="$mysql_backend_libs"
		)
	fi
	local mycmakeargs=(
		-DSOCI_STATIC=OFF
		-DSOCI_TESTS="$(usex test)"
		-DSOCI_DB2=OFF
		-DSOCI_FIREBIRD=OFF
		-DSOCI_MYSQL="$(usex mysql 'yes' $(usex mariadb))"
		-DSOCI_ODBC="$(usex odbc)"
		-DSOCI_ORACLE="$(usex oracle)"
		-DSOCI_POSTGRESQL="$(usex postgres)"
		-DSOCI_SQLITE3="$(usex sqlite)"
		"${mysql_backend_cmake_args[@]}"
	)
	cmake_src_configure
}
