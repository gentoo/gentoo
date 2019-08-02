# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

MULTILIB_WRAPPED_HEADERS+=(
	/usr/include/mysql/my_config.h
)

# wrap the config script
MULTILIB_CHOST_TOOLS=( /usr/bin/mysql_config )

DESCRIPTION="C client library for MariaDB/MySQL"
HOMEPAGE="https://dev.mysql.com/downloads/connector/c/"
LICENSE="GPL-2"

SRC_URI="https://dev.mysql.com/get/Downloads/Connector-C/${P}-src.tar.gz"
S="${WORKDIR}/${P}-src"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86"

SUBSLOT="18"
SLOT="0/${SUBSLOT}"
IUSE="libressl static-libs"

CDEPEND="
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
	!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
	"
RDEPEND="${CDEPEND}
	!dev-db/mariadb-connector-c[mysqlcompat]
	"
DEPEND="${CDEPEND}"

DOCS=( README )
PATCHES=(
	"${FILESDIR}/mysql_com.patch"
	"${FILESDIR}/20028_all_mysql-5.6-gcc7.patch"
	"${FILESDIR}/6.1.11-openssl-1.1.patch"
)

src_prepare() {
	sed -i -e 's/CLIENT_LIBS/CONFIG_CLIENT_LIBS/' "${S}/scripts/CMakeLists.txt" || die
	if use libressl ; then
		sed -i 's/OPENSSL_MAJOR_VERSION STREQUAL "1"/OPENSSL_MAJOR_VERSION STREQUAL "2"/' \
			"${S}/cmake/ssl.cmake" || die
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
		-DMYSQL_UNIX_ADDR="${EPREFIX}/var/run/mysqld/mysqld.sock"
		-DWITH_ZLIB=system
		-DENABLE_DTRACE=OFF
		-DWITH_SSL=system
		-DLIBMYSQL_OS_OUTPUT_NAME=mysqlclient
		-DSHARED_LIB_PATCH_VERSION="0"
	)
	cmake-utils_src_configure
}

multilib_src_install_all() {
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}

pkg_preinst() {
	if [[ -z ${REPLACING_VERSIONS} && -e "${EROOT}/usr/$(get_libdir)/libmysqlclient.so" ]] ; then
		elog "Due to ABI changes when switching between different client libraries,"
		elog "revdep-rebuild must find and rebuild all packages linking to libmysqlclient."
		elog "Please run: revdep-rebuild --library libmysqlclient.so.${SUBSLOT}"
		ewarn "Failure to run revdep-rebuild may cause issues with other programs or libraries"
	fi
}
