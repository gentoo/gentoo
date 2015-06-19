# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/openssl-tpm-engine/openssl-tpm-engine-0.4.1.ebuild,v 1.3 2014/07/06 17:44:29 alonbl Exp $

EAPI=4

MY_P="${P/-tpm-/_tpm_}"

DESCRIPTION="This provides a OpenSSL engine that uses private keys stored in TPM hardware"
HOMEPAGE="http://trousers.sourceforge.net"
SRC_URI="mirror://sourceforge/trousers/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RDEPEND=">=dev-libs/openssl-0.9.8
	>=app-crypt/trousers-0.2.8"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# autotools way too old to fix it properly
	sed -i 's/^\(create_tpm_key_LDADD.*\)/\1 -L@OPENSSL_LIB_DIR@ -lcrypto/' Makefile.in
}

src_configure() {
	econf --with-openssl=/usr
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc openssl.cnf.sample README
}
