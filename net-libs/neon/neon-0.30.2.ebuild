# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools libtool multilib-minimal

DESCRIPTION="HTTP and WebDAV client library"
HOMEPAGE="http://www.webdav.org/neon/"
SRC_URI="http://www.webdav.org/neon/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/27"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc expat gnutls kerberos libproxy libressl nls pkcs11 ssl static-libs zlib"
RESTRICT="test"

RDEPEND="expat? ( dev-libs/expat:0=[${MULTILIB_USEDEP}] )
	!expat? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	gnutls? (
		app-misc/ca-certificates
		net-libs/gnutls:0=[${MULTILIB_USEDEP}]
		pkcs11? ( dev-libs/pakchois:0=[${MULTILIB_USEDEP}] )
	)
	!gnutls? ( ssl? (
		libressl? ( dev-libs/libressl:=[${MULTILIB_USEDEP}] )
		!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
		pkcs11? ( dev-libs/pakchois:0=[${MULTILIB_USEDEP}] )
	) )
	kerberos? ( virtual/krb5:0=[${MULTILIB_USEDEP}] )
	libproxy? ( net-libs/libproxy:0=[${MULTILIB_USEDEP}] )
	nls? ( virtual/libintl:0=[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib:0=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/neon-config
)

src_prepare() {
	# Use CHOST-prefixed version of xml2-config for cross-compilation.
	sed -e "s/AC_CHECK_PROG(XML2_CONFIG,/AC_CHECK_TOOL(XML2_CONFIG,/" -i macros/neon-xml-parser.m4 || die "sed failed"

	# Use OpenSSL <1.1 compatibility code with LibreSSL.
	# Functions EVP_PKEY_up_ref(), EVP_PKEY_get0_RSA(), RSA_meth_get0_app_data(), RSA_meth_new(), RSA_meth_free(),
	# RSA_meth_set_priv_enc(), RSA_meth_set0_app_data() are not implemented in LibreSSL 2.5.1.
	sed -e "s/#if OPENSSL_VERSION_NUMBER < 0x10100000L/& || defined(LIBRESSL_VERSION_NUMBER)/" -i src/ne_openssl.c src/ne_pkcs11.c || die "sed failed"

	eapply_user

	AT_M4DIR="macros" eautoreconf

	elibtoolize

	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=()

	if has_version sys-libs/glibc; then
		einfo "Enabling SSL library thread-safety using POSIX threads..."
		myconf+=(--enable-threadsafe-ssl=posix)
	fi

	if use expat; then
		myconf+=(--with-expat)
	else
		myconf+=(--with-libxml2)
	fi

	if use gnutls; then
		myconf+=(--with-ssl=gnutls --with-ca-bundle="${EPREFIX}/etc/ssl/certs/ca-certificates.crt")
	elif use ssl; then
		myconf+=(--with-ssl=openssl)
	fi

	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--enable-shared \
		$(use_with kerberos gssapi) \
		$(use_with libproxy) \
		$(use_enable nls) \
		$(use_with pkcs11 pakchois) \
		$(use_enable static-libs static) \
		$(use_with zlib) \
		"${myconf[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install-{config,headers,lib,man,nls}

	if multilib_is_native_abi && use doc; then
		(
			docinto html
			dodoc -r doc/html/*
		)
	fi
}

multilib_src_install_all() {
	find "${ED}" -name "*.la" -delete

	dodoc AUTHORS BUGS NEWS README THANKS TODO
}
