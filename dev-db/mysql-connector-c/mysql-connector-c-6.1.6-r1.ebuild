# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CMAKE_MIN_VERSION="2.8.12"

inherit cmake-multilib eutils

MULTILIB_WRAPPED_HEADERS+=(
	/usr/include/mysql/my_config.h
)

# wrap the config script
MULTILIB_CHOST_TOOLS=( /usr/bin/mysql_config )

DESCRIPTION="C client library for MariaDB/MySQL"
HOMEPAGE="https://dev.mysql.com/downloads/connector/c/"
LICENSE="GPL-2"

SRC_URI="mirror://mysql/Downloads/Connector-C/${P}-src.tar.gz"
S="${WORKDIR}/${P}-src"
KEYWORDS="~amd64 ~ia64 ~ppc64 ~x86"

SLOT="0/18"
IUSE="+ssl static-libs"

CDEPEND="
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	ssl? ( dev-libs/openssl:=[${MULTILIB_USEDEP}] )
	"
RDEPEND="${CDEPEND}
	!dev-db/mysql[client-libs(+)]
	!dev-db/mysql-cluster[client-libs(+)]
	!dev-db/mariadb[client-libs(+)]
	!dev-db/mariadb-connector-c[mysqlcompat]
	!dev-db/mariadb-galera[client-libs(+)]
	!dev-db/percona-server[client-libs(+)]
	"
DEPEND="${CDEPEND}"

DOCS=( README Docs/ChangeLog )

src_prepare() {
	epatch "${FILESDIR}/openssl-cmake-detection.patch" \
		"${FILESDIR}/conn-c-includes.patch" \
		"${FILESDIR}/mysql_com.patch"
	epatch_user
}

multilib_src_configure() {
	mycmakeargs+=(
		-DINSTALL_LAYOUT=RPM
		-DINSTALL_LIBDIR=$(get_libdir)
		-DWITH_DEFAULT_COMPILER_OPTIONS=OFF
		-DWITH_DEFAULT_FEATURE_SET=OFF
		-DENABLED_LOCAL_INFILE=ON
		-DMYSQL_UNIX_ADDR="${EPREFIX}/var/run/mysqld/mysqld.sock"
		-DWITH_ZLIB=system
		-DENABLE_DTRACE=OFF
		-DWITH_SSL=$(usex ssl system bundled)
	)
	cmake-utils_src_configure
}

multilib_src_install_all() {
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}
