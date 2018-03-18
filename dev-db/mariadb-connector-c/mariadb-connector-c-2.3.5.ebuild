# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS_INHERIT=""
if [[ "${PV}" == 9999 ]] ; then
	VCS_INHERIT="git-r3"
	EGIT_REPO_URI="https://github.com/MariaDB/connector-c.git"
	KEYWORDS="~arm ~hppa ~ia64 ~ppc64 ~sparc"
else
	MY_PN=${PN#mariadb-}
	MY_PV=${PV/_b/-b}
	SRC_URI="https://downloads.mariadb.org/f/${MY_PN}-${PV%_beta}/${PN}-${MY_PV}-src.tar.gz?serve -> ${P}-src.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}-src"
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc64 ~sparc ~x86"
fi

inherit cmake-utils multilib-minimal toolchain-funcs ${VCS_INHERIT}

MULTILIB_CHOST_TOOLS=( /usr/bin/mariadb_config )

MULTILIB_WRAPPED_HEADERS+=(
	/usr/include/mariadb/my_config.h
)

DESCRIPTION="C client library for MariaDB/MySQL"
HOMEPAGE="http://mariadb.org/"
LICENSE="LGPL-2.1"

SLOT="0/2"
IUSE="mysqlcompat +ssl static-libs"

DEPEND="sys-libs/zlib:=[${MULTILIB_USEDEP}]
	virtual/libiconv:=[${MULTILIB_USEDEP}]
	ssl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
	"
RDEPEND="${DEPEND}
	mysqlcompat? (
	!dev-db/mysql[client-libs(+)]
	!dev-db/mysql-cluster[client-libs(+)]
	!dev-db/mariadb[client-libs(+)]
	!dev-db/mariadb-galera[client-libs(+)]
	!dev-db/percona-server[client-libs(+)]
	!dev-db/mysql-connector-c )
	!>=dev-db/mariadb-10.2.0[client-libs(+)]
	"
PATCHES=( "${FILESDIR}/gentoo-layout-2.0.patch" )

src_prepare() {
	local gpluginconf="${T}/gentoo-plugins.cmake"
	touch "${gpluginconf}" || die
	# Plugins cannot be disabled by a build switch, redefine them in our own file to be included
	cmake-utils_src_prepare
}

src_configure() {
	# bug 508724 mariadb cannot use ld.gold
	tc-ld-disable-gold
	multilib-minimal_src_configure
}

multilib_src_configure() {
	mycmakeargs+=(
		-DMYSQL_UNIX_ADDR="${EPREFIX}/var/run/mysqld/mysqld.sock"
		-DWITH_EXTERNAL_ZLIB=ON
		-DWITH_OPENSSL=$(usex ssl ON OFF)
		-DWITH_MYSQLCOMPAT=$(usex mysqlcompat ON OFF)
		-DLIB_INSTALL_DIR=$(get_libdir)
		-DPLUGIN_INSTALL_DIR=$(get_libdir)/mariadb/plugin
		-DDOCS_INSTALL_DIR=share/docs
		-DBIN_INSTALL_DIR=bin
		-DINSTALL_PATH=$(get_libdir)
		-DLIBSUFFIX_INSTALL_DIR=maarrria
	)
	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install
	if use mysqlcompat ; then
		dosym libmariadb.so.2 /usr/$(get_libdir)/libmysqlclient.so.18
		dosym libmariadb.so.2 /usr/$(get_libdir)/libmysqlclient.so
	fi
}

multilib_src_install_all() {
	if ! use static-libs ; then
		find "${D}" -name "*.a" -delete || die
	fi
	if use mysqlcompat ; then
		dosym mariadb_config /usr/bin/mysql_config
		dosym mariadb /usr/include/mysql
	fi
}
