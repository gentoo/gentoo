# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

MY_P="lib${P}"

DESCRIPTION="A database abstraction layer"
HOMEPAGE="https://www.linuxnetworks.de/doc/index.php/OpenDBX"
SRC_URI="https://www.linuxnetworks.de/opendbx/download/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x64-solaris"
IUSE="firebird +mysql oracle postgres sqlite test"
RESTRICT="firebird? ( bindist ) !test? ( test )"

REQUIRED_USE="|| ( firebird mysql oracle postgres sqlite )"

RDEPEND="
	sys-libs/readline:=
	mysql? ( dev-db/mysql-connector-c:0= )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( dev-db/sqlite:3 )
	oracle? ( dev-db/oracle-instantclient[sdk] )
	firebird? ( dev-db/firebird )
"
DEPEND="
	${RDEPEND}
	app-doc/doxygen
	app-text/docbook2X
"

PATCHES=( "${FILESDIR}/${PN}-doxy.patch" )

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use oracle && [[ ! -d ${ORACLE_HOME} ]]; then
		die "Oracle support requested, but ORACLE_HOME not set to a valid directory!"
	fi
}

src_configure() {
	local backends=""

	use firebird && backends="${backends} firebird"
	use mysql && backends="${backends} mysql"
	use oracle && backends="${backends} oracle"
	use postgres && backends="${backends} pgsql"
	use sqlite && backends="${backends} sqlite3"

	use mysql && append-cppflags -I/usr/include/mysql
	use firebird && append-cppflags -I/opt/firebird/include

	if use oracle ; then
		# Traditionally, OCI header files are provided in:
		append-cppflags -I"${ORACLE_HOME}"/rdbms/public
		# But newer versions merged them with additional SDKs:
		append-cppflags -I"${ORACLE_HOME}"/sdk/include
		# Depending on the client package ORACLE_HOME refers to,
		# we need to find the libraries in varying locations:
		# - gentoo instantclient has multilib (dev-db/oracle-instantclient)
		append-ldflags -L"${ORACLE_HOME}"/$(get_libdir)
		# - vanilla full client lacks multilib (LINUX*_client{,_home}.zip)
		append-ldflags -L"${ORACLE_HOME}"/lib
		# - vanilla instantclient lacks libdir (instantclient-*.zip)
		append-ldflags -L"${ORACLE_HOME}"
	fi

	# Can't build with C++17 and greater, see
	# https://bugs.gentoo.org/attachment.cgi?id=848120
	append-cxxflags -std=c++11

	econf --with-backends="${backends}"
}

src_compile() {
	# bug #322221
	emake -j1
}

src_install() {
	emake -j1 install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog README

	find "${ED}" -name '*.a' -delete || die
	find "${ED}" -name '*.la' -delete || die
}
