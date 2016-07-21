# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit multilib qt4-build-multilib

DESCRIPTION="The SQL module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
fi

IUSE="freetds mysql oci8 odbc postgres qt3support +sqlite"

REQUIRED_USE="
	|| ( freetds mysql oci8 odbc postgres sqlite )
"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,qt3support=,${MULTILIB_USEDEP}]
	freetds? ( dev-db/freetds )
	mysql? ( virtual/libmysqlclient:=[${MULTILIB_USEDEP}] )
	oci8? ( >=dev-db/oracle-instantclient-basic-11.2.0.4[${MULTILIB_USEDEP}] )
	odbc? ( || (
		>=dev-db/unixODBC-2.3.2-r2[${MULTILIB_USEDEP}]
		>=dev-db/libiodbc-3.52.8-r2[${MULTILIB_USEDEP}]
	) )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( >=dev-db/sqlite-3.8.3:3[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/sql
	src/plugins/sqldrivers"

multilib_src_configure() {
	local myconf=(
		$(qt_native_use freetds  sql-tds    plugin)
		$(qt_use        mysql    sql-mysql  plugin) $(use mysql && echo "-I${EPREFIX}/usr/include/mysql -L${EPREFIX}/usr/$(get_libdir)/mysql")
		$(qt_use        oci8     sql-oci    plugin) $(use oci8 && echo "-I${ORACLE_HOME}/include -L${ORACLE_HOME}/$(get_libdir)")
		$(qt_use        odbc     sql-odbc   plugin) $(use odbc && echo "-I${EPREFIX}/usr/include/iodbc")
		$(qt_native_use postgres sql-psql   plugin) $(use postgres && multilib_is_native_abi && echo "-I${EPREFIX}/usr/include/postgresql/pgsql")
		$(qt_use        sqlite   sql-sqlite plugin) $(use sqlite && echo -system-sqlite)
		-no-sql-db2
		-no-sql-ibase
		-no-sql-sqlite2
		-no-sql-symsql
		$(qt_use qt3support)
		-no-accessibility -no-xmlpatterns -no-multimedia -no-audio-backend -no-phonon
		-no-phonon-backend -no-svg -no-webkit -no-script -no-scripttools -no-declarative
		-system-zlib -no-gif -no-libtiff -no-libpng -no-libmng -no-libjpeg -no-openssl
		-no-cups -no-dbus -no-gtkstyle -no-nas-sound -no-opengl
		-no-sm -no-xshape -no-xvideo -no-xsync -no-xinerama -no-xcursor -no-xfixes
		-no-xrandr -no-xrender -no-mitshm -no-fontconfig -no-freetype -no-xinput -no-xkb
		-no-glib
	)
	qt4_multilib_src_configure
}
