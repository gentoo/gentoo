# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/MariaDB/mariadb-connector-c.git"
else
	MY_PN=${PN#mariadb-}
	MY_PV=${PV/_b/-b}
	SRC_URI="https://downloads.mariadb.com/Connectors/c/connector-c-${PV}/${P}-src.tar.gz"
	S="${WORKDIR%/}/${PN}-${MY_PV}-src"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~x86"
fi

inherit cmake-multilib flag-o-matic toolchain-funcs

DESCRIPTION="C client library for MariaDB/MySQL"
HOMEPAGE="https://mariadb.org/"

LICENSE="LGPL-2.1"
SLOT="0/3"
IUSE="+curl gnutls kerberos +ssl static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	virtual/libiconv:=[${MULTILIB_USEDEP}]
	curl? ( net-misc/curl[${MULTILIB_USEDEP}] )
	kerberos? (
		|| (
			app-crypt/mit-krb5[${MULTILIB_USEDEP}]
			app-crypt/heimdal[${MULTILIB_USEDEP}]
		)
	)
	ssl? (
		gnutls? ( >=net-libs/gnutls-3.3.24:=[${MULTILIB_USEDEP}] )
		!gnutls? ( dev-libs/openssl:=[${MULTILIB_USEDEP}] )
	)
"
BDEPEND="test? ( dev-db/mariadb[server] )"
RDEPEND="${DEPEND}"

MULTILIB_CHOST_TOOLS=( /usr/bin/mariadb_config )
MULTILIB_WRAPPED_HEADERS+=( /usr/include/mariadb/mariadb_version.h )

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.3-fix-pkconfig-file.patch
	"${FILESDIR}"/${PN}-3.3.4-remove-zstd.patch
)

src_prepare() {
	# Should be able to drop this once bug #926121 is fixed and
	# https://github.com/mariadb-corporation/mariadb-connector-c/commit/395641549ac72bc31def6d8b64e09093336aef72
	# is in a release.
	sed -i -e '/SET(WARNING_AS_ERROR "-Werror")/d' CMakeLists.txt || die

	# These tests the remote_io plugin which requires network access
	sed -i 's/{"test_remote1", test_remote1, TEST_CONNECTION_NEW, 0, NULL, NULL},//g' "unittest/libmariadb/misc.c" || die

	# These tests don't work with --skip-grant-tables
	sed -i 's/{"test_conc366", test_conc366, TEST_CONNECTION_DEFAULT, 0, NULL, NULL},//g' "unittest/libmariadb/connection.c" || die
	sed -i 's/{"test_conc66", test_conc66, TEST_CONNECTION_DEFAULT, 0, NULL,  NULL},//g' "unittest/libmariadb/connection.c" || die

	# [Warning] Aborted connection 2078 to db: 'test' user: 'root' host: '' (Got an error reading communication packets)
	# Not sure about this one - might also require network access
	sed -i 's/{"test_default_auth", test_default_auth, TEST_CONNECTION_NONE, 0, NULL, NULL},//g' "unittest/libmariadb/connection.c" || die

	cmake_src_prepare
}

src_configure() {
	# mariadb cannot use ld.gold, bug #508724
	tc-ld-disable-gold

	# bug #855233 (MDEV-11914, MDEV-25633) at least
	filter-lto

	cmake-multilib_src_configure
}

multilib_src_configure() {
	local mycmakeargs=(
		-DWITH_EXTERNAL_ZLIB=ON
		-DWITH_SSL:STRING=$(usex ssl $(usex gnutls GNUTLS OPENSSL) OFF)
		-DWITH_CURL=$(usex curl)
		-DWITH_ICONV=ON
		-DCLIENT_PLUGIN_AUTH_GSSAPI_CLIENT:STRING=$(usex kerberos DYNAMIC OFF)
		-DMARIADB_UNIX_ADDR="${EPREFIX}/var/run/mysqld/mysqld.sock"
		-DINSTALL_LIBDIR="$(get_libdir)"
		-DINSTALL_MANDIR=share/man
		-DINSTALL_PCDIR="$(get_libdir)/pkgconfig"
		-DINSTALL_PLUGINDIR="$(get_libdir)/mariadb/plugin"
		-DINSTALL_BINDIR=bin
		-DWITH_UNIT_TESTS=$(usex test)
	)

	cmake_src_configure
}

multilib_src_test() {
	mkdir -vp "${T}/mysql/data" || die

	mysql_install_db --no-defaults --datadir="${T}/mysql/data" || die
	mysqld --no-defaults --datadir="${T}/mysql/data" --socket="${T}/mysql/mysql.sock" --skip-grant-tables --skip-networking &

	while ! mysqladmin ping --socket="${T}/mysql/mysql.sock" --silent ; do
		sleep 1
	done

	cd unittest/libmariadb || die
	MYSQL_TEST_SOCKET="${T}/mysql/mysql.sock" MARIADB_CC_TEST=1 ctest --verbose || die
}

multilib_src_install_all() {
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}
