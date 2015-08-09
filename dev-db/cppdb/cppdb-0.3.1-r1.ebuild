# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils multilib

DESCRIPTION="An SQL connectivity library for platform and database independent connectivity"
HOMEPAGE="http://cppcms.com/sql/cppdb/"
SRC_URI="mirror://sourceforge/cppcms/${P}.tar.bz2"

LICENSE="|| ( Boost-1.0 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples mysql mysql_internal odbc odbc_internal postgres postgres_internal sqlite sqlite_internal"

DEPEND="
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql )
	sqlite? ( dev-db/sqlite:3 )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use_disable mysql MYSQL)
		$(cmake-utils_use mysql_internal MYSQL_BACKEND_INTERNAL)
		$(cmake-utils_use_disable odbc ODBC)
		$(cmake-utils_use odbc_internal ODBC_BACKEND_INTERNAL)
		$(cmake-utils_use_disable postgres PQ)
		$(cmake-utils_use postgres_internal PQ_BACKEND_INTERNAL)
		$(cmake-utils_use_disable sqlite SQLITE)
		$(cmake-utils_use sqlite_internal SQLITE_BACKEND_INTERNAL)
		-DLIBDIR=$(get_libdir)"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use doc; then
		rm docs/build.txt || die
		dodoc -r docs/*
		dohtml -r html/*
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
