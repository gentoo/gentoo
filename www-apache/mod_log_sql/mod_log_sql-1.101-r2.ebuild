# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit apache-module eutils

DESCRIPTION="An Apache module for logging to an SQL (MySQL) database"
HOMEPAGE="http://www.outoforder.cc/projects/apache/mod_log_sql/"
SRC_URI="http://www.outoforder.cc/downloads/${PN}/${P}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="dbi ssl"

DEPEND="virtual/mysql
	dbi? ( dev-db/libdbi )
	ssl? ( dev-libs/openssl:0 )"
RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="1.101/42_${PN}"
APACHE2_MOD_DEFINE="LOG_SQL"

APACHE2_EXECFILES="
	.libs/${PN}_logio.so
	.libs/${PN}_mysql.so
	.libs/${PN}_ssl.so"

DOCFILES="AUTHORS CHANGELOG docs/README docs/manual.html \
contrib/create_tables.sql contrib/make_combined_log.pl contrib/mysql_import_combined_log.pl"

need_apache2_4

src_prepare() {
	epatch "${FILESDIR}"/${P}-apache-2.4.patch
}

src_configure() {
	local myconf="--with-apxs=${APXS}"
	use ssl && myconf="${myconf} --with-ssl-inc=/usr"
	use ssl || myconf="${myconf} --without-ssl-inc"
	use dbi && myconf="${myconf} --with-dbi=/usr"
	use dbi || myconf="${myconf} --without-dbi"
	econf ${myconf}
}

src_compile() {
	emake
}

src_install() {
	use dbi && APACHE2_EXECFILES="${APACHE2_EXECFILES} .libs/${PN}_dbi.so"
	apache-module_src_install
}

pkg_postinst() {
	use dbi && APACHE2_MOD_DEFINE="${APACHE2_MOD_DEFINE} DBI"
	apache-module_pkg_postinst
	einfo "Refer to /usr/share/doc/${PF}/ for scripts"
	einfo "on how to create logging tables."
}
