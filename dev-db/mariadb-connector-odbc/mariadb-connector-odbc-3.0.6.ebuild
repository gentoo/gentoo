# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multilib-minimal

DESCRIPTION="MariaDB Connector/ODBC"
HOMEPAGE="https://downloads.mariadb.org/connector-odbc/"
SRC_URI="https://downloads.mariadb.org/interstitial/connector-odbc-${PV}/${P}-ga-src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/3"
KEYWORDS="~amd64 ~x86"
IUSE="ssl gnutls test"

S="${S}-ga-src"

DEPEND="dev-db/mariadb-connector-c"
RDEPEND="${DEPEND}"
BDEPEND=""

multilib_src_configure() {
	append-cppflags $(mariadb_config --cflags)
	local mycmakeargs=(
	-DWITH_SSL:STRING=$(usex ssl $(usex gnutls GNUTLS OPENSSL) OFF)
	-DWITH_UNIT_TESTS=$(usex test ON OFF)
	-DMARIADB_LINK_DYNAMIC=YES
	-DUSE_SYSTEM_INSTALLED_LIB=YES
	#-DCMAKE_C_FLAGS="$(mariadb_config --cflags)"
	)
	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_install() {
	cmake-utils_src_install
}

multilib_src_install_all() {
	dodir /usr/share/${PN}
	sed -e "s,lib/lib,$(get_libdir)/lib,g" < "${FILESDIR}/odbcinst.ini" > "${D}/usr/share/${PN}/odbcinst.ini"
}

pkg_config() {
	[ "${ROOT}" != "/" ] && die "Sorry, non-standard ROOT setting is not supported."

	if /usr/bin/odbcinst -q -d -n maodbc &>/dev/null; then
		einfo "maodbc (MariaDB ODBC driver) has already been installed."
	else
		ebegin "Installing maodbc (MariaDB ODBC driver)"
		/usr/bin/odbcinst -i -d -f /usr/share/${PN}/odbcinst.ini
		eend $?
	fi
}
