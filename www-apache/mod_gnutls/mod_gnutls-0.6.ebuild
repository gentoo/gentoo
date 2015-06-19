# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_gnutls/mod_gnutls-0.6.ebuild,v 1.1 2014/05/22 08:03:41 polynomial-c Exp $

EAPI=5
inherit apache-module autotools eutils

DESCRIPTION="mod_gnutls uses GnuTLS to provide SSL/TLS encryption for Apache2, similarly to mod_ssl"
HOMEPAGE="https://mod.gnutls.org/"
SRC_URI="https://mod.gnutls.org/downloads/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

DEPEND=">=net-libs/gnutls-2.10.0:="
RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="47_${PN}"
APACHE2_MOD_DEFINE="GNUTLS"

DOCFILES="CHANGELOG NOTICE README"

need_apache2

src_prepare() {
	epatch "${FILESDIR}/${PN}_apr_memcache_m4_dirty.patch"

	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die

	epatch_user
	eautoreconf
}

src_configure() {
	econf --with-apxs="${APXS}"
}

src_compile() {
	emake
}

src_install() {
	mv -f src/.libs/libmod_gnutls.so src/.libs/${PN}.so
	keepdir /var/cache/${PN}
	apache-module_src_install
}
