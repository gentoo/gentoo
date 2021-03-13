# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

# wrap the config script
MULTILIB_CHOST_TOOLS=( /usr/bin/mysql_config )

DESCRIPTION="C client library for MariaDB/MySQL"
HOMEPAGE="https://dev.mysql.com/downloads/"
SRC_URI="https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-boost-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0/21"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 sparc ~x86"
IUSE="ldap libressl static-libs"

RDEPEND="
	>=app-arch/lz4-0_p131:=[${MULTILIB_USEDEP}]
	app-arch/zstd:=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	ldap? ( dev-libs/cyrus-sasl:=[${MULTILIB_USEDEP}] )
	libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
	!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

# Avoid file collisions, #692580
RDEPEND+=" !<dev-db/mysql-5.6.45-r1"
RDEPEND+=" !=dev-db/mysql-5.7.23*"
RDEPEND+=" !=dev-db/mysql-5.7.24*"
RDEPEND+=" !=dev-db/mysql-5.7.25*"
RDEPEND+=" !=dev-db/mysql-5.7.26-r0"
RDEPEND+=" !=dev-db/mysql-5.7.27-r0"
RDEPEND+=" !<dev-db/percona-server-5.7.26.29-r1"

DOCS=( README )

S="${WORKDIR}/mysql-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-8.0.22-always-build-decompress-utilities.patch
	"${FILESDIR}"/${PN}-8.0.19-do-not-install-comp_err.patch
	"${FILESDIR}"/${PN}-8.0.23-libressl.patch
)

src_prepare() {
	sed -i -e 's/CLIENT_LIBS/CONFIG_CLIENT_LIBS/' "scripts/CMakeLists.txt" || die

	# All these are for the server only.
	# Disable rpm call which would trigger sandbox, #692368
	sed -i \
		-e '/MYSQL_CHECK_LIBEVENT/d' \
		-e '/MYSQL_CHECK_RAPIDJSON/d' \
		-e '/MYSQL_CHECK_ICU/d' \
		-e '/MYSQL_CHECK_EDITLINE/d' \
		-e '/MYSQL_CHECK_CURL/d' \
		-e '/ADD_SUBDIRECTORY(man)/d' \
		-e '/ADD_SUBDIRECTORY(share)/d' \
		-e '/INCLUDE(cmake\/boost/d' \
		-e 's/MY_RPM rpm/MY_RPM rpmNOTEXISTENT/' \
		CMakeLists.txt || die

	# Skip building clients
	echo > client/CMakeLists.txt || die

	# Forcefully disable auth plugin
	if ! use ldap ; then
		sed -i -e '/MYSQL_CHECK_SASL/d' CMakeLists.txt || die
		echo > libmysql/authentication_ldap/CMakeLists.txt || die
	fi

	cmake_src_prepare
}

multilib_src_configure() {
	CMAKE_BUILD_TYPE="RelWithDebInfo"

	local mycmakeargs=(
		-DCMAKE_C_FLAGS_RELWITHDEBINFO=-DNDEBUG
		-DCMAKE_CXX_FLAGS_RELWITHDEBINFO=-DNDEBUG
		-DINSTALL_LAYOUT=RPM
		-DINSTALL_LIBDIR=$(get_libdir)
		-DWITH_DEFAULT_COMPILER_OPTIONS=OFF
		-DENABLED_LOCAL_INFILE=ON
		-DMYSQL_UNIX_ADDR="${EPREFIX}/run/mysqld/mysqld.sock"
		-DWITH_LZ4=system
		-DWITH_NUMA=OFF
		-DWITH_SSL=system
		-DWITH_ZLIB=system
		-DWITH_ZSTD=system
		-DLIBMYSQL_OS_OUTPUT_NAME=mysqlclient
		-DSHARED_LIB_PATCH_VERSION="0"
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DWITHOUT_SERVER=ON
	)

	cmake_src_configure
}

multilib_src_install_all() {
	doman \
		man/my_print_defaults.1 \
		man/perror.1 \
		man/zlib_decompress.1

	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}
