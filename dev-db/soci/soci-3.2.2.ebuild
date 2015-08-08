# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A db access library for C++ that makes the illusion of embedding SQL queries in the regular C++ code"
HOMEPAGE="http://soci.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"
LICENSE="Boost-1.0"
SLOT="0"
IUSE="boost doc +empty firebird mysql odbc oracle postgres sqlite"

DEPEND="boost? ( dev-libs/boost )
	firebird? ( dev-db/firebird )
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	oracle? ( dev-db/oracle-instantclient-basic )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND=${DEPEND}

src_configure() {
	local mycmakeargs="$(cmake-utils_use_with boost )
		$(cmake-utils_use empty SOCI_EMPTY)
		$(cmake-utils_use_with firebird FIREBIRD)
		$(cmake-utils_use_with mysql MYSQL)
		$(cmake-utils_use_with odbc ODBC)
		$(cmake-utils_use_with oracle ORACLE)
		$(cmake-utils_use_with postgres POSTGRESQL)
		$(cmake-utils_use_with sqlite SQLITE3)
		-DWITH_DB2=OFF" #use MYCMAKEARGS if you want enable IBM DB2 support
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS CHANGES
	if use doc; then
		dohtml -r doc/*
	fi
}
