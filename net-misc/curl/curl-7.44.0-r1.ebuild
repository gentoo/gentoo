# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils prefix multilib-minimal

DESCRIPTION="A Client that groks URLs"
HOMEPAGE="http://curl.haxx.se/"
SRC_URI="http://curl.haxx.se/download/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="adns http2 idn ipv6 kerberos ldap metalink rtmp samba ssh ssl static-libs test threads"
IUSE+=" curl_ssl_axtls curl_ssl_gnutls curl_ssl_libressl curl_ssl_nss +curl_ssl_openssl curl_ssl_polarssl curl_ssl_winssl"
IUSE+=" elibc_Winnt"

#lead to lots of false negatives, bug #285669
RESTRICT="test"

RDEPEND="ldap? ( >=net-nds/openldap-2.4.38-r1[${MULTILIB_USEDEP}] )
	ssl? (
		curl_ssl_axtls? (
			>=net-libs/axtls-1.4.9-r1[${MULTILIB_USEDEP}]
			app-misc/ca-certificates
		)
		curl_ssl_gnutls? (
			|| (
				(
					>=net-libs/gnutls-3.2.15[static-libs?,${MULTILIB_USEDEP}]
					>=dev-libs/nettle-2.6[${MULTILIB_USEDEP}]
				)
				(
					=net-libs/gnutls-2.12*[nettle,static-libs?,${MULTILIB_USEDEP}]
					>=dev-libs/nettle-2.6[${MULTILIB_USEDEP}]
				)
				(
					=net-libs/gnutls-2.12*[-nettle,static-libs?,${MULTILIB_USEDEP}]
					>=dev-libs/libgcrypt-1.5.3[static-libs?,${MULTILIB_USEDEP}]
				)
			)
			app-misc/ca-certificates
		)
		curl_ssl_libressl? (
			dev-libs/libressl[static-libs?,${MULTILIB_USEDEP}]
		)
		curl_ssl_openssl? (
			>=dev-libs/openssl-1.0.1h-r2[static-libs?,${MULTILIB_USEDEP}]
		)
		curl_ssl_nss? (
			>=dev-libs/nss-3.15.4[${MULTILIB_USEDEP}]
			app-misc/ca-certificates
		)
		curl_ssl_polarssl? (
			>=net-libs/polarssl-1.3.4:=[${MULTILIB_USEDEP}]
			app-misc/ca-certificates
		)
	)
	http2? ( net-libs/nghttp2[${MULTILIB_USEDEP}] )
	idn? ( >=net-dns/libidn-1.28[static-libs?,${MULTILIB_USEDEP}] )
	adns? ( >=net-dns/c-ares-1.10.0-r1[${MULTILIB_USEDEP}] )
	kerberos? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
	metalink? ( >=media-libs/libmetalink-0.1.1[${MULTILIB_USEDEP}] )
	rtmp? ( >=media-video/rtmpdump-2.4_p20131018[${MULTILIB_USEDEP}] )
	ssh? ( >=net-libs/libssh2-1.4.3[static-libs?,${MULTILIB_USEDEP}] )
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508-r13
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"

# Do we need to enforce the same ssl backend for curl and rtmpdump? Bug #423303
#	rtmp? (
#		media-video/rtmpdump
#		curl_ssl_gnutls? ( media-video/rtmpdump[gnutls] )
#		curl_ssl_openssl? ( media-video/rtmpdump[-gnutls,ssl] )
#	)

# ssl providers to be added:
# fbopenssl  $(use_with spnego)

# krb4 http://web.mit.edu/kerberos/www/krb4-end-of-life.html

DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	test? (
		sys-apps/diffutils
		dev-lang/perl
	)"

# c-ares must be disabled for threads
# only one ssl provider can be enabled
REQUIRED_USE="
	curl_ssl_winssl? ( elibc_Winnt )
	threads? ( !adns )
	ssl? (
		^^ (
			curl_ssl_axtls
			curl_ssl_gnutls
			curl_ssl_libressl
			curl_ssl_openssl
			curl_ssl_nss
			curl_ssl_polarssl
			curl_ssl_winssl
		)
	)"

DOCS=( CHANGES README docs/FEATURES docs/INTERNALS \
	docs/MANUAL docs/FAQ docs/BUGS docs/CONTRIBUTE)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/curl/curlbuild.h
)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/curl-config
)

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-7.30.0-prefix.patch \
		"${FILESDIR}"/${PN}-respect-cflags-3.patch \
		"${FILESDIR}"/${PN}-fix-gnutls-nettle.patch

	sed -i '/LD_LIBRARY_PATH=/d' configure.ac || die #382241

	epatch_user
	eprefixify curl-config.in
	eautoreconf
}

multilib_src_configure() {
	einfo "\033[1;32m**************************************************\033[00m"

	# We make use of the fact that later flags override earlier ones
	# So start with all ssl providers off until proven otherwise
	local myconf=()
	myconf+=( --without-axtls --without-gnutls --without-nss --without-polarssl --without-ssl --without-winssl )
	myconf+=( --with-ca-bundle="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt )
	if use ssl ; then
		if use curl_ssl_axtls; then
			einfo "SSL provided by axtls"
			einfo "NOTE: axtls is meant for embedded systems and"
			einfo "may not be the best choice as an ssl provider"
			myconf+=( --with-axtls )
		fi
		if use curl_ssl_gnutls; then
			einfo "SSL provided by gnutls"
			if has_version ">=net-libs/gnutls-3.2.15[${MULTILIB_USEDEP}]" || has_version "=net-libs/gnutls-2.12*[nettle,${MULTILIB_USEDEP}]"; then
				einfo "gnutls compiled with dev-libs/nettle"
				myconf+=( --with-gnutls --with-nettle )
			else
				einfo "gnutls compiled with dev-libs/libgcrypt"
				myconf+=( --with-gnutls --without-nettle )
			fi
		fi
		if use curl_ssl_nss; then
			einfo "SSL provided by nss"
			myconf+=( --with-nss )
		fi
		if use curl_ssl_polarssl; then
			einfo "SSL provided by polarssl"
			einfo "NOTE: polarssl is meant for embedded systems and"
			einfo "may not be the best choice as an ssl provider"
			myconf+=( --with-polarssl )
		fi
		if use curl_ssl_libressl; then
			einfo "SSL provided by LibreSSL"
			myconf+=( --with-ssl --with-ca-path="${EPREFIX}"/etc/ssl/certs )
		fi
		if use curl_ssl_openssl; then
			einfo "SSL provided by openssl"
			myconf+=( --with-ssl --with-ca-path="${EPREFIX}"/etc/ssl/certs )
		fi
		if use curl_ssl_winssl; then
			einfo "SSL provided by Windows"
			myconf+=( --with-winssl )
		fi
	else
		einfo "SSL disabled"
	fi
	einfo "\033[1;32m**************************************************\033[00m"

	# These configuration options are organized alphabetically
	# within each category.  This should make it easier if we
	# ever decide to make any of them contingent on USE flags:
	# 1) protocols first.  To see them all do
	# 'grep SUPPORT_PROTOCOLS configure.ac'
	# 2) --enable/disable options second.
	# 'grep -- --enable configure | grep Check | awk '{ print $4 }' | sort
	# 3) --with/without options third.
	# grep -- --with configure | grep Check | awk '{ print $4 }' | sort
	ECONF_SOURCE="${S}" \
	econf \
		--enable-dict \
		--enable-file \
		--enable-ftp \
		--enable-gopher \
		--enable-http \
		--enable-imap \
		$(use_enable ldap) \
		$(use_enable ldap ldaps) \
		--enable-pop3 \
		--enable-rt  \
		--enable-rtsp \
		$(use_enable samba smb) \
		$(use_with ssh libssh2) \
		--enable-smtp \
		--enable-telnet \
		--enable-tftp \
		$(use_enable adns ares) \
		--enable-cookies \
		--enable-hidden-symbols \
		$(use_enable ipv6) \
		--enable-largefile \
		--enable-manual \
		--enable-proxy \
		--disable-soname-bump \
		--disable-sspi \
		$(use_enable static-libs static) \
		$(use_enable threads threaded-resolver) \
		--disable-versioned-symbols \
		--without-cyassl \
		--without-darwinssl \
		$(use_with idn libidn) \
		$(use_with kerberos gssapi "${EPREFIX}"/usr) \
		--without-krb4 \
		$(use_with metalink libmetalink) \
		$(use_with http2 nghttp2) \
		$(use_with rtmp librtmp) \
		--without-spnego \
		--without-winidn \
		--with-zlib \
		"${myconf[@]}"

	if ! multilib_is_native_abi; then
		# avoid building the client
		sed -i -e '/SUBDIRS/s:src::' Makefile || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all

	rm -rf "${ED}"/etc/

	# https://sourceforge.net/tracker/index.php?func=detail&aid=1705197&group_id=976&atid=350976
	insinto /usr/share/aclocal
	doins docs/libcurl/libcurl.m4
}
