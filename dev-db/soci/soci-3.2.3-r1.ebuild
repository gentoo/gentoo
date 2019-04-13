# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Makes the illusion of embedding SQL queries in the regular C++ code"
HOMEPAGE="http://soci.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boost doc +empty firebird mysql odbc oracle postgres sqlite static-libs test"

RDEPEND="
	firebird? ( dev-db/firebird )
	mysql? ( dev-db/mysql-connector-c:= )
	odbc? ( dev-db/unixODBC )
	oracle? ( dev-db/oracle-instantclient-basic )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${RDEPEND}
	boost? ( dev-libs/boost )
"

src_configure() {
	local mycmakeargs=(
		-DWITH_BOOST=$(usex boost)
		-DSOCI_EMPTY=$(usex empty)
		-DWITH_FIREBIRD=$(usex firebird)
		-DWITH_MYSQL=$(usex mysql)
		-DWITH_ODBC=$(usex odbc)
		-DWITH_ORACLE=$(usex oracle)
		-DWITH_POSTGRESQL=$(usex postgres)
		-DWITH_SQLITE3=$(usex sqlite)
		-DSOCI_STATIC=$(usex static-libs)
		-DSOCI_TESTS=$(usex test)
		-DWITH_DB2=OFF
	)
	#use MYCMAKEARGS if you want enable IBM DB2 support
	cmake-utils_src_configure
}

src_install() {
	use doc && local HTML_DOCS=( doc/. )
	cmake-utils_src_install
}
