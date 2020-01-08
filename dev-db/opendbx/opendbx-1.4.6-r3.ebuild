# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools flag-o-matic

DESCRIPTION="OpenDBX - A database abstraction layer"
HOMEPAGE="https://www.linuxnetworks.de/doc/index.php/OpenDBX"
SRC_URI="https://www.linuxnetworks.de/opendbx/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="firebird +man +mysql oracle postgres sqlite"
RESTRICT="firebird? ( bindist )"

RDEPEND="mysql? ( dev-db/mysql-connector-c:0= )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( dev-db/sqlite:3 )
	oracle? ( dev-db/oracle-instantclient-basic )
	firebird? ( dev-db/firebird )"
DEPEND="${RDEPEND}
	man? ( app-doc/doxygen
		app-text/docbook2X )"

REQUIRED_USE="|| ( firebird mysql oracle postgres sqlite )"

PATCHES=( "${FILESDIR}/${PN}-doxy.patch"
	"${FILESDIR}/${PN}-man-optional.patch" )

pkg_setup() {
	if use oracle && [[ ! -d ${ORACLE_HOME} ]]
	then
		die "Oracle support requested, but ORACLE_HOME not set to a valid directory!"
	fi
}

src_prepare() {
	default
	eautoreconf
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
	use oracle && append-ldflags -L"${ORACLE_HOME}"/lib

	econf --with-backends="${backends}" --enable-manpages="$(usex man yes no)"
}

src_compile() {
	# bug #322221
	emake -j1
}

src_install() {
	emake -j1 install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog README

	rm -f "${D}"/usr/$(get_libdir)/opendbx/*.{a,la}
}
