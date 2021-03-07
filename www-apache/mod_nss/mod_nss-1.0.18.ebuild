# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools apache-module

DESCRIPTION="SSL/TLS module for the Apache HTTP server"
HOMEPAGE="https://pagure.io/mod_nss"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ecc"

# https://bugs.gentoo.org/742455
RESTRICT="test"

DEPEND="
	dev-libs/nspr
	dev-libs/nss"
RDEPEND="${DEPEND}
	net-dns/bind-tools"
BDEPEND="virtual/pkgconfig"

APACHE2_MOD_CONF="47_${PN}"
APACHE2_MOD_DEFINE="NSS"

need_apache2

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

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
	einstalldocs

	APACHE_MODULESDIR="/usr/$(get_libdir)/apache2/modules"
	apache-module_src_install
}
