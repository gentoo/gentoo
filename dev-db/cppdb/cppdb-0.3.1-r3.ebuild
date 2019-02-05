# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="SQL connectivity library for platform and database independent connectivity"
HOMEPAGE="http://cppcms.com/sql/cppdb/"
SRC_URI="mirror://sourceforge/cppcms/${P}.tar.bz2"

LICENSE="|| ( Boost-1.0 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples mysql mysql_internal odbc odbc_internal postgres postgres_internal sqlite sqlite_internal"

DEPEND="
	mysql? ( dev-db/mysql-connector-c:= )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DDISABLE_MYSQL=$(usex !mysql)
		-DMYSQL_BACKEND_INTERNAL=$(usex mysql_internal)
		-DDISABLE_ODBC=$(usex !odbc)
		-DODBC_BACKEND_INTERNAL=$(usex odbc_internal)
		-DDISABLE_PQ=$(usex !postgres)
		-DPQ_BACKEND_INTERNAL=$(usex postgres_internal)
		-DDISABLE_SQLITE=$(usex !sqlite)
		-DSQLITE_BACKEND_INTERNAL=$(usex sqlite_internal)
		-DLIBDIR=$(get_libdir)
	)

	cmake-utils_src_configure
}

src_install() {
	if use doc; then
		rm docs/build.txt || die
		dodoc docs/*
		local HTML_DOCS=( html/. )
	fi
	cmake-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
