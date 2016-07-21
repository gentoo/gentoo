# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools apache-module eutils

DESCRIPTION="SSL/TLS module for the Apache HTTP server"
HOMEPAGE="https://fedorahosted.org/mod_nss/"
SRC_URI="https://fedorahosted.org/released/mod_nss/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ecc"

DEPEND="
	>=dev-libs/nspr-4.6.4
	>=dev-libs/nss-3.11.4
	sys-apps/sed
	virtual/pkgconfig
"
RDEPEND="
	>=dev-libs/nspr-4.6.4
	>=dev-libs/nss-3.11.4
	net-dns/bind-tools
"

APACHE2_MOD_CONF="47_${PN}"
APACHE2_MOD_DEFINE="NSS"

DOCFILES="NOTICE README"

need_apache2

src_prepare() {
	default

	# setup proper exec name
	sed -i -e 's/certutil/nsscertutil/' gencert.in || die "sed failed"
	eautoreconf
}

src_configure() {
	econf $(use_enable ecc) --with-apxs=${APXS}
}

src_compile() {
	# default src_compile fails:
	# In file included from mod_nss.c:16:0:
	# mod_nss.h:51:18: fatal error: nspr.h: No such file or directory
	emake
}

src_install() {
	# override broken build system
	mv .libs/libmodnss.so .libs/"${PN}".so || die "cannot move lib"
	dosbin gencert nss_pcache
	dodoc docs/mod_nss.html
	newbin migrate.pl nss_migrate
	dodir /etc/apache2/nss
	apache-module_src_install
}
