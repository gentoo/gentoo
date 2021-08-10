# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake

inherit cmake-multilib flag-o-matic

DESCRIPTION="MariaDB Connector/ODBC"
HOMEPAGE="https://downloads.mariadb.org/connector-odbc/"
SRC_URI="https://downloads.mariadb.org/interstitial/connector-odbc-${PV}/${P}-ga-src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/3.1"
KEYWORDS="~amd64 ~x86"
IUSE="gnutls ssl"

S="${S}-ga-src"

DEPEND="=dev-db/mariadb-connector-c-$(ver_cut 1-2)*
	dev-db/unixODBC"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare

	cp "${FILESDIR}/odbcinst.ini" . || die
	sed -e "s,lib/lib,$(get_libdir)/lib,g" -i "odbcinst.ini" || die
}

multilib_src_configure() {
	append-cppflags $(mariadb_config --cflags || die)
	local mycmakeargs=(
		-DWITH_SSL:STRING=$(usex ssl $(usex gnutls GNUTLS OPENSSL) OFF)
		-DMARIADB_LINK_DYNAMIC=YES
		-DUSE_SYSTEM_INSTALLED_LIB=YES
		-DINSTALL_DOC_DIR="/usr/share/doc/${P}"
		-DINSTALL_LICENSE_DIR="/usr/share/doc/${P}"
		#-DCMAKE_C_FLAGS="$(mariadb_config --cflags)"
	)
	cmake_src_configure
}

multilib_src_install_all() {
	insinto /usr/share/${PN}
	doins odbcinst.ini
}

pkg_postinst() {
	elog "Please remember to use emerge --config =${P} to install the ODBC ini files."
	elog "Alterantively run: /usr/bin/odbcinst -i -d -f /usr/share/${PN}/odbcinst.ini"
}

pkg_config() {
	[[ -n "${ROOT}" ]] && die "Sorry, non-standard ROOT setting is not supported."

	if /usr/bin/odbcinst -q -d -n maodbc &>/dev/null; then
		einfo "maodbc (MariaDB ODBC driver) has already been installed."
	else
		ebegin "Installing maodbc (MariaDB ODBC driver)"
		/usr/bin/odbcinst -i -d -f /usr/share/${PN}/odbcinst.ini
		eend ${?} || die
	fi
}
