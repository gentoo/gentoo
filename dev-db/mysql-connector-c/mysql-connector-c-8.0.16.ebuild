# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

# wrap the config script
MULTILIB_CHOST_TOOLS=( /usr/bin/mysql_config )

DESCRIPTION="C client library for MariaDB/MySQL"
HOMEPAGE="https://dev.mysql.com/downloads/"
LICENSE="GPL-2"

SRC_URI="https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-boost-${PV}.tar.gz"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

SLOT="0/21"
IUSE="ldap libressl +ssl static-libs"

RDEPEND="
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	ldap? ( dev-libs/cyrus-sasl:=[${MULTILIB_USEDEP}] )
	ssl? (
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
		!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
	)
	"
DEPEND="${RDEPEND}"

DOCS=( README )

S="${WORKDIR}/mysql-${PV}"

PATCHES=( "${FILESDIR}/8.0.16-libressl.patch" )

src_prepare() {
	sed -i -e 's/CLIENT_LIBS/CONFIG_CLIENT_LIBS/' "${S}/scripts/CMakeLists.txt" || die

	# All these are for the server only
	sed -i \
		-e '/MYSQL_CHECK_LIBEVENT/d' \
		-e '/MYSQL_CHECK_RAPIDJSON/d' \
		-e '/MYSQL_CHECK_ICU/d' \
		-e '/MYSQL_CHECK_RE2/d' \
		-e '/MYSQL_CHECK_LZ4/d' \
		-e '/MYSQL_CHECK_EDITLINE/d' \
		-e '/MYSQL_CHECK_CURL/d' \
		-e '/ADD_SUBDIRECTORY(man)/d' \
		-e '/ADD_SUBDIRECTORY(share)/d' \
		-e '/INCLUDE(cmake\/boost/d' \
		CMakeLists.txt || die

	# Skip building clients
	echo > client/CMakeLists.txt || die

	# Forcefully disable auth plugin
	if ! use ldap ; then
		sed -i -e '/MYSQL_CHECK_SASL/d' CMakeLists.txt || die
		echo > libmysql/authentication_ldap/CMakeLists.txt || die
	fi

	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DINSTALL_LAYOUT=RPM
		-DINSTALL_LIBDIR=$(get_libdir)
		-DWITH_DEFAULT_COMPILER_OPTIONS=OFF
		-DWITH_DEFAULT_FEATURE_SET=OFF
		-DENABLED_LOCAL_INFILE=ON
		-DMYSQL_UNIX_ADDR="${EPREFIX}/run/mysqld/mysqld.sock"
		-DWITH_ZLIB=system
		-DWITH_SSL=$(usex ssl system wolfssl)
		-DLIBMYSQL_OS_OUTPUT_NAME=mysqlclient
		-DSHARED_LIB_PATCH_VERSION="0"
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DWITHOUT_SERVER=ON
	)
	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install
}

multilib_src_install_all() {
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}
