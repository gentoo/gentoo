# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_auth_pgsql/mod_auth_pgsql-2.0.3-r2.ebuild,v 1.1 2015/05/09 07:43:14 pacho Exp $

EAPI=5
inherit eutils apache-module multilib

DESCRIPTION="This module allows user authentication against information stored in a PostgreSQL database"
HOMEPAGE="http://www.giuseppetanzilli.it/mod_auth_pgsql2/"
SRC_URI="http://www.giuseppetanzilli.it/mod_auth_pgsql2/dist/${P}.tar.gz"

LICENSE="freedist"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-db/postgresql:*"
RDEPEND="${DEPEND}"

APXS2_ARGS="-a -c -I/usr/include/postgresql -L/usr/$(get_libdir)/postgresql -lpq mod_auth_pgsql.c"

APACHE2_MOD_CONF="80_mod_auth_pgsql"
APACHE2_MOD_DEFINE="AUTH_PGSQL"

DOCFILES="INSTALL README mod_auth_pgsql.html"

need_apache2_4

src_prepare() {
	# Debian patches
	epatch "${FILESDIR}"/${P}-documentation.patch
	epatch "${FILESDIR}"/${P}-encoding.patch
	epatch "${FILESDIR}"/${P}-apache-2.4.patch
	epatch "${FILESDIR}"/${P}-fixdoublefree.patch
}

src_install() {
	apache-module_src_install
	fperms 600 "${APACHE_MODULES_CONFDIR}"/${APACHE2_MOD_CONF}.conf
}
