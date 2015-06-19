# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_nss/mod_nss-1.0.8-r1.ebuild,v 1.5 2012/10/16 03:31:29 patrick Exp $

EAPI="2"

inherit base autotools apache-module

DESCRIPTION="SSL/TLS module for the Apache HTTP server"
HOMEPAGE="http://directory.fedoraproject.org/wiki/Mod_nss"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ecc"

DEPEND=">=dev-libs/nss-3.11.4
	>=dev-libs/nspr-4.6.4
	virtual/pkgconfig
	sys-apps/sed"

RDEPEND=">=dev-libs/nss-3.11.4
	>=dev-libs/nspr-4.6.4
	net-dns/bind-tools"

APACHE2_MOD_CONF="47_${PN}"
APACHE2_MOD_DEFINE="NSS"

DOCFILES="NOTICE README"

need_apache2_2

src_prepare() {
	# setup proper exec name
	sed -i -e 's/certutil/nsscertutil/' gencert.in || die "sed failed"
	eautoreconf
}

src_configure() {
	econf $(use_enable ecc) --with-apxs=${APXS} || die "econf failed"
}

src_compile() {
	base_src_compile
}

src_install() {
	# override broken build system
	mv .libs/libmodnss.so .libs/"${PN}".so || die "cannot move lib"
	dosbin gencert nss_pcache
	dohtml docs/mod_nss.html
	newbin migrate.pl nss_migrate
	dodir /etc/apache2/nss
	apache-module_src_install
}

pkg_postinst() {
	apache-module_pkg_postinst

	elog "If you need to generate a SSL certificate,"
	elog "please use gencert tool from net-dns/bind-tools"
}
