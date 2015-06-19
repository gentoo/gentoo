# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-misc/litmus/litmus-0.13.ebuild,v 1.3 2014/02/10 03:00:12 floppym Exp $

EAPI="5"

inherit autotools eutils

# TODO: FAIL (connection refused by '...' port 80: Connection refused)
# We can't run tests that connect with the internet.
RESTRICT="test"

DESCRIPTION="WebDAV server protocol compliance test suite"
HOMEPAGE="http://www.webdav.org/neon/litmus"
SRC_URI="http://www.webdav.org/neon/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug expat gnutls kerberos libproxy +libxml2 pkcs11 +ssl threads"
REQUIRED_USE="?? ( gnutls ssl )
	^^ ( expat libxml2 )
	threads? ( ^^ ( gnutls ssl ) )"

NEON_DEP="net-libs/neon:0="
DEPEND="${NEON_DEP}[expat?,gnutls?,kerberos?,libproxy?,pkcs11?,ssl?,zlib]

	expat? ( dev-libs/expat:0 )
	gnutls? ( net-libs/gnutls:0 )
	kerberos? ( app-crypt/mit-krb5:0 )
	libproxy? ( net-libs/libproxy:0 )
	libxml2? ( dev-libs/libxml2:2 )
	pkcs11? ( dev-libs/pakchois:0 )
	ssl? ( dev-libs/openssl:0 )"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog FAQ NEWS README THANKS TODO )

src_prepare() {
	# Accept Neon 0.30.
	epatch "${FILESDIR}/${PV}-autotools-neon-version.patch"

	eautoreconf
}

src_configure() {
	# No EGD available in the Portage tree.
	econf \
		--enable-warnings \
		--without-egd \
		--with-neon \
		--without-included-neon \
		$(use_enable debug) \
		$(use_enable threads threadsafe-ssl posix) \
		$(use_with gnutls ssl gnutls) \
		$(use_with ssl    ssl openssl) \
		$(use_with expat) \
		$(use_with libxml2) \
		$(use_with kerberos gssapi) \
		$(use_with pkcs11 pakchois) \
		$(use_with libproxy)
}
