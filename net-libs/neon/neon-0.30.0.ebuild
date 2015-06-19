# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/neon/neon-0.30.0.ebuild,v 1.11 2014/03/16 02:51:12 vapier Exp $

EAPI="5"

inherit autotools libtool

DESCRIPTION="HTTP and WebDAV client library"
HOMEPAGE="http://www.webdav.org/neon/"
SRC_URI="http://www.webdav.org/neon/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/27"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc expat gnutls kerberos libproxy nls pkcs11 ssl static-libs zlib"
IUSE_LINGUAS="cs de fr ja nn pl ru tr zh_CN"
for lingua in ${IUSE_LINGUAS}; do
	IUSE+=" linguas_${lingua}"
done
unset lingua
RESTRICT="test"

RDEPEND="expat? ( dev-libs/expat:0= )
	!expat? ( dev-libs/libxml2:2= )
	gnutls? (
		app-misc/ca-certificates
		net-libs/gnutls:0=
		pkcs11? ( dev-libs/pakchois:0= )
	)
	!gnutls? ( ssl? (
		dev-libs/openssl:0=
		pkcs11? ( dev-libs/pakchois:0= )
	) )
	kerberos? ( virtual/krb5:0= )
	libproxy? ( net-libs/libproxy:0= )
	nls? ( virtual/libintl:0= )
	zlib? ( sys-libs/zlib:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	local lingua linguas
	for lingua in ${IUSE_LINGUAS}; do
		use linguas_${lingua} && linguas+=" ${lingua}"
	done
	sed -e "s/ALL_LINGUAS=.*/ALL_LINGUAS=\"${linguas}\"/" -i configure.in

	AT_M4DIR="macros" eautoreconf

	elibtoolize
}

src_configure() {
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

src_install() {
	emake DESTDIR="${D}" install-{config,headers,lib,man,nls}

	find "${ED}" -name "*.la" -delete

	if use doc; then
		emake DESTDIR="${D}" install-html
	fi

	dodoc AUTHORS BUGS NEWS README THANKS TODO
}
