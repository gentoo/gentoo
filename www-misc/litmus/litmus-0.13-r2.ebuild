# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="WebDAV server protocol compliance test suite"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug expat gnutls kerberos libproxy +libxml2 pkcs11 +ssl threads"
REQUIRED_USE="
	?? ( gnutls ssl )
	^^ ( expat libxml2 )
	threads? (
		^^ ( gnutls ssl )
	)
"

# TODO: FAIL (connection refused by '...' port 80: Connection refused)
# We can't run tests that connect with the internet.
RESTRICT="test"

DEPEND="
	net-libs/neon:0=[expat?,gnutls?,kerberos?,libproxy?,pkcs11?,ssl?,zlib]
	expat? ( dev-libs/expat:0 )
	gnutls? ( net-libs/gnutls:0 )
	kerberos? ( app-crypt/mit-krb5:0 )
	libproxy? ( net-libs/libproxy:0 )
	libxml2? ( dev-libs/libxml2:2= )
	pkcs11? ( dev-libs/pakchois:0 )
	ssl? ( dev-libs/openssl:0 )
"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-autotools-neon-version.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-warnings
		--without-egd
		--with-neon
		--without-included-neon
		$(use_enable debug)
		$(use_enable threads threadsafe-ssl posix)
		$(use_with gnutls ssl gnutls)
		$(use_with ssl ssl openssl)
		$(use_with expat)
		$(use_with libxml2)
		$(use_with kerberos gssapi)
		$(use_with pkcs11 pakchois)
		$(use_with libproxy)
	)

	econf "${myeconfargs[@]}"
}
