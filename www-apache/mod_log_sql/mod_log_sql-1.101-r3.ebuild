# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit apache-module

DESCRIPTION="An Apache module for logging to an SQL (MySQL) database"
HOMEPAGE="http://www.outoforder.cc/projects/apache/mod_log_sql/"
SRC_URI="http://www.outoforder.cc/downloads/${PN}/${P}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="dbi ssl"

DEPEND="dev-db/mysql-connector-c:0=
	dbi? ( dev-db/libdbi )
	ssl? ( dev-libs/openssl:0= )"
RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="1.101/42_${PN}"
APACHE2_MOD_DEFINE="LOG_SQL"

APACHE2_EXECFILES="
	.libs/${PN}_logio.so
	.libs/${PN}_mysql.so
	.libs/${PN}_ssl.so"

DOCS=( AUTHORS CHANGELOG docs/README contrib/create_tables.sql
	contrib/make_combined_log.pl contrib/mysql_import_combined_log.pl )
HTML_DOCS=( docs/manual.html )

PATCHES=( "${FILESDIR}"/${P}-apache-2.4.patch )

need_apache2_4

pkg_setup() {
	_init_apache2
	_init_apache2_late
}

src_configure() {
	local myconf="--with-apxs=${APXS}"
	myconf="${myconf} $(usex ssl --with-ssl-inc=/usr --without-ssl-inc)"
	myconf="${myconf} $(usex dbi --with-dbi=/usr --without-dbi)"
	econf ${myconf}
}

src_compile() {
	emake
}

src_install() {
	use dbi && APACHE2_EXECFILES="${APACHE2_EXECFILES} .libs/${PN}_dbi.so"
	apache-module_src_install
	einstalldocs
}

pkg_postinst() {
	use dbi && APACHE2_MOD_DEFINE="${APACHE2_MOD_DEFINE} DBI"
	apache-module_pkg_postinst
	einfo "Refer to /usr/share/doc/${PF}/ for scripts"
	einfo "on how to create logging tables."
}
