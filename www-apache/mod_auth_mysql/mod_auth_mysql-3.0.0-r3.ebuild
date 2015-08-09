# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit apache-module eutils multilib

DESCRIPTION="Basic authentication for Apache using a MySQL database"
HOMEPAGE="http://modauthmysql.sourceforge.net/"
SRC_URI="mirror://sourceforge/modauthmysql/${P}.tar.gz"

LICENSE="Apache-1.1"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

DEPEND="virtual/mysql
		sys-libs/zlib"
RDEPEND="${DEPEND}
		!www-apache/mod-auth-mysql"

APXS2_ARGS="-c -I/usr/include/mysql -L/usr/$(get_libdir)/mysql -Wl,-R/usr/$(get_libdir)/mysql -lmysqlclient_r -lm -lz ${PN}.c"
APACHE2_MOD_CONF="12_${PN}"
APACHE2_MOD_DEFINE="AUTH_MYSQL"

DOCFILES="README CONFIGURE"

need_apache2_2

src_prepare() {
	epatch "${FILESDIR}/${P}-apache-2.2.patch"
	epatch "${FILESDIR}/${P}-htpasswd2-auth-style.patch"
}
