# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="C client library for MariaDB/MySQL"
HOMEPAGE="https://dev.mysql.com/downloads/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/mysql/mysql-server.git"

	inherit git-r3
else
	SRC_URI="https://dev.mysql.com/get/Downloads/MySQL-$(ver_cut 1-2)/mysql-boost-${PV}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

	S="${WORKDIR}/mysql-${PV}"
fi

LICENSE="GPL-2"
SLOT="0/21"
IUSE="ldap static-libs"

RDEPEND="
	>=app-arch/lz4-1.9.4:=[${MULTILIB_USEDEP}]
	app-arch/zstd:=[${MULTILIB_USEDEP}]
	dev-libs/openssl:=[${MULTILIB_USEDEP}]
	net-libs/libtirpc:=[${MULTILIB_USEDEP}]
	>=virtual/zlib-1.2.13:=[${MULTILIB_USEDEP}]
	ldap? ( dev-libs/cyrus-sasl:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
# Avoid file collisions, #692580
RDEPEND+="
	!<dev-db/mysql-5.6.45-r1
	!=dev-db/mysql-5.7.23*
	!=dev-db/mysql-5.7.24*
	!=dev-db/mysql-5.7.25*
	!=dev-db/mysql-5.7.26-r0
	!=dev-db/mysql-5.7.27-r0
	!<dev-db/percona-server-5.7.26.29-r1
"

DOCS=( README )

# Wrap the config script
MULTILIB_CHOST_TOOLS=( /usr/bin/mysql_config )

PATCHES=(
	"${FILESDIR}"/${PN}-8.0.36-always-build-decompress-utilities.patch
	"${FILESDIR}"/${PN}-8.0.19-do-not-install-comp_err.patch
	"${FILESDIR}"/${PN}-8.0.27-res_n.patch
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
	# Code is now requiring C++17 due to https://github.com/mysql/mysql-server/commit/236ab55bedd8c9eacd80766d85edde2a8afacd08
	append-cxxflags -std=c++17

	local mycmakeargs=(
		-DCMAKE_C_FLAGS_RELWITHDEBINFO=-DNDEBUG
		-DCMAKE_CXX_FLAGS_RELWITHDEBINFO=-DNDEBUG
		-DINSTALL_LAYOUT=RPM
		-DINSTALL_LIBDIR=$(get_libdir)
		-DWITH_DEFAULT_COMPILER_OPTIONS=OFF
		-DENABLED_LOCAL_INFILE=ON
		-DMYSQL_UNIX_ADDR="${EPREFIX}/run/mysqld/mysqld.sock"
		# Automagically uses LLD with not using LTO (bug #710272, #775845)
		-DUSE_LD_LLD=OFF
		-DWITH_LZ4=system
		-DWITH_NUMA=OFF
		-DWITH_SSL=system
		-DWITH_ZLIB=system
		-DWITH_ZSTD=system
		-DLIBMYSQL_OS_OUTPUT_NAME=mysqlclient
		-DSHARED_LIB_PATCH_VERSION="0"
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DWITHOUT_SERVER=ON
		-DWITH_BUILD_ID=OFF
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
