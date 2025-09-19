# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="SOCI - The C++ Database Access Library"
HOMEPAGE="https://sourceforge.net/projects/soci/"
SRC_URI="https://sourceforge.net/projects/soci/files/soci/${P}/${P}.tar.gz/download -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="mysql odbc oracle postgres sqlite static-libs test"
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
	>=dev-libs/boost-1.85.0-r1
	mysql? ( dev-db/mysql:* )
	odbc? ( dev-db/unixODBC )
	oracle? ( dev-db/oracle-instantclient:=[sdk] )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( dev-db/sqlite )
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DSOCI_STATIC="$(usex static-libs)"
		-DSOCI_TESTS="$(usex test)"
	)
	cmake_src_configure
}
