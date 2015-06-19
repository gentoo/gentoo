# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_log_sql/mod_log_sql-1.101-r1.ebuild,v 1.6 2014/08/10 20:16:44 slyfox Exp $

inherit apache-module

DESCRIPTION="An Apache module for logging to an SQL (MySQL) database"
HOMEPAGE="http://www.outoforder.cc/projects/apache/mod_log_sql/"
SRC_URI="http://www.outoforder.cc/downloads/${PN}/${P}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="dbi ssl"

DEPEND="virtual/mysql
		dbi? ( dev-db/libdbi )
		ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="1.101/42_${PN}"
APACHE2_MOD_DEFINE="LOG_SQL"

APACHE2_EXECFILES="
	.libs/${PN}_dbi.so
	.libs/${PN}_logio.so
	.libs/${PN}_mysql.so
	.libs/${PN}_ssl.so"

DOCFILES="AUTHORS CHANGELOG docs/README docs/manual.html \
contrib/create_tables.sql contrib/make_combined_log.pl contrib/mysql_import_combined_log.pl"

need_apache2_2

src_compile() {
	local myconf="--with-apxs=${APXS}"
	use ssl && myconf="${myconf} --with-ssl-inc=/usr"
	use ssl || myconf="${myconf} --without-ssl-inc"
	use dbi && myconf="${myconf} --with-dbi=/usr"
	use dbi || myconf="${myconf} --without-dbi"
	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

pkg_postinst() {
	use dbi && APACHE2_MOD_DEFINE="${APACHE2_MOD_DEFINE} DBI"
	apache-module_pkg_postinst
	einfo "Refer to /usr/share/doc/${PF}/ for scripts"
	einfo "on how to create logging tables."
}
