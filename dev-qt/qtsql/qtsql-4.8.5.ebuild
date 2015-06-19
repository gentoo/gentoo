# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtsql/qtsql-4.8.5.ebuild,v 1.12 2014/12/28 15:44:26 titanofold Exp $

EAPI=4

inherit multilib qt4-build

DESCRIPTION="The SQL module for the Qt toolkit"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi
IUSE="firebird freetds mysql oci8 odbc postgres qt3support +sqlite"

REQUIRED_USE="
	|| ( firebird freetds mysql oci8 odbc postgres sqlite )
"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,qt3support=]
	firebird? ( dev-db/firebird )
	freetds? ( dev-db/freetds )
	mysql? ( virtual/mysql )
	oci8? ( dev-db/oracle-instantclient-basic )
	odbc? ( || ( dev-db/unixODBC dev-db/libiodbc ) )
	postgres? ( dev-db/postgresql )
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/sql
		src/plugins/sqldrivers"

	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		include/Qt
		include/QtCore
		include/QtSql
		src/src.pro
		src/corelib
		src/plugins
		src/tools/tools.pro"

	qt4-build_pkg_setup
}

src_configure() {
	myconf+="
		$(qt_use firebird sql-ibase  plugin)
		$(qt_use freetds  sql-tds    plugin)
		$(qt_use mysql    sql-mysql  plugin) $(use mysql && echo "-I${EPREFIX}/usr/include/mysql -L${EPREFIX}/usr/$(get_libdir)/mysql")
		$(qt_use oci8     sql-oci    plugin) $(use oci8 && echo "-I${ORACLE_HOME}/include -L${ORACLE_HOME}/$(get_libdir)")
		$(qt_use odbc     sql-odbc   plugin) $(use odbc && echo "-I${EPREFIX}/usr/include/iodbc")
		$(qt_use postgres sql-psql   plugin) $(use postgres && echo "-I${EPREFIX}/usr/include/postgresql/pgsql")
		$(qt_use sqlite   sql-sqlite plugin) $(use sqlite && echo -system-sqlite)
		-no-sql-db2
		-no-sql-sqlite2
		-no-sql-symsql
		$(qt_use qt3support)
		-no-accessibility -no-xmlpatterns -no-multimedia -no-audio-backend -no-phonon
		-no-phonon-backend -no-svg -no-webkit -no-script -no-scripttools -no-declarative
		-system-zlib -no-gif -no-libtiff -no-libpng -no-libmng -no-libjpeg -no-openssl
		-no-cups -no-dbus -no-gtkstyle -no-nas-sound -no-opengl
		-no-sm -no-xshape -no-xvideo -no-xsync -no-xinerama -no-xcursor -no-xfixes
		-no-xrandr -no-xrender -no-mitshm -no-fontconfig -no-freetype -no-xinput -no-xkb
		-no-glib"

	qt4-build_src_configure
}
