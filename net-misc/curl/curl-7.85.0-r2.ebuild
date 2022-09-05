# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools prefix multilib-minimal verify-sig

DESCRIPTION="A Client that groks URLs"
HOMEPAGE="https://curl.haxx.se/"
SRC_URI="https://curl.haxx.se/download/${P}.tar.xz
	verify-sig? ( https://curl.haxx.se/download/${P}.tar.xz.asc )"

LICENSE="curl"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+adns alt-svc brotli +ftp gnutls gopher hsts +http2 idn +imap ipv6 kerberos ldap mbedtls nss +openssl +pop3 +progress-meter rtmp samba +smtp ssh ssl sslv3 static-libs test telnet +tftp zstd"
IUSE+=" curl_ssl_gnutls curl_ssl_mbedtls curl_ssl_nss +curl_ssl_openssl"
IUSE+=" nghttp3 quiche"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/danielstenberg.asc

# Only one default ssl provider can be enabled
REQUIRED_USE="
	ssl? (
		^^ (
			curl_ssl_gnutls
			curl_ssl_mbedtls
			curl_ssl_nss
			curl_ssl_openssl
		)
	)"

# lead to lots of false negatives, bug #285669
RESTRICT="!test? ( test )"

RDEPEND="ldap? ( net-nds/openldap:=[${MULTILIB_USEDEP}] )
	brotli? ( app-arch/brotli:=[${MULTILIB_USEDEP}] )
	ssl? (
		gnutls? (
			net-libs/gnutls:0=[static-libs?,${MULTILIB_USEDEP}]
			dev-libs/nettle:0=[${MULTILIB_USEDEP}]
			app-misc/ca-certificates
		)
		mbedtls? (
			net-libs/mbedtls:0=[${MULTILIB_USEDEP}]
			app-misc/ca-certificates
		)
		openssl? (
			dev-libs/openssl:0=[sslv3(-)=,static-libs?,${MULTILIB_USEDEP}]
		)
		nss? (
			dev-libs/nss:0[${MULTILIB_USEDEP}]
			dev-libs/nss-pem
			app-misc/ca-certificates
		)
	)
	http2? ( net-libs/nghttp2:=[${MULTILIB_USEDEP}] )
	nghttp3? (
		net-libs/nghttp3[${MULTILIB_USEDEP}]
		net-libs/ngtcp2[ssl,${MULTILIB_USEDEP}]
	)
	quiche? ( >=net-libs/quiche-0.3.0[${MULTILIB_USEDEP}] )
	idn? ( net-dns/libidn2:0=[static-libs?,${MULTILIB_USEDEP}] )
	adns? ( net-dns/c-ares:0=[${MULTILIB_USEDEP}] )
	kerberos? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
	rtmp? ( media-video/rtmpdump[${MULTILIB_USEDEP}] )
	ssh? ( net-libs/libssh2[${MULTILIB_USEDEP}] )
	sys-libs/zlib[${MULTILIB_USEDEP}]
	zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )"

# Do we need to enforce the same ssl backend for curl and rtmpdump? Bug #423303
#	rtmp? (
#		media-video/rtmpdump
#		curl_ssl_gnutls? ( media-video/rtmpdump[gnutls] )
#		curl_ssl_openssl? ( media-video/rtmpdump[-gnutls,ssl] )
#	)

DEPEND="${RDEPEND}"
BDEPEND="dev-lang/perl
	virtual/pkgconfig
	test? (
		sys-apps/diffutils
	)
	verify-sig? ( sec-keys/openpgp-keys-danielstenberg )"

DOCS=( CHANGES README docs/{FEATURES.md,INTERNALS.md,FAQ,BUGS.md,CONTRIBUTE.md} )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/curl/curlbuild.h
)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/curl-config
)

PATCHES=(
	"${FILESDIR}"/${PN}-7.30.0-prefix.patch
	"${FILESDIR}"/${PN}-respect-cflags-3.patch
)

src_prepare() {
	default

	eprefixify curl-config.in
	eautoreconf
}

multilib_src_configure() {
	# We make use of the fact that later flags override earlier ones
	# So start with all ssl providers off until proven otherwise
	# TODO: in the future, we may want to add wolfssl (https://www.wolfssl.com/)
	local myconf=()

	myconf+=( --without-gnutls --without-mbedtls --without-nss --without-ssl )
	myconf+=( --without-ca-fallback --with-ca-bundle="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt  )
	#myconf+=( --without-default-ssl-backend )
	if use ssl ; then
		if use gnutls || use curl_ssl_gnutls; then
			einfo "SSL provided by gnutls"
			myconf+=( --with-gnutls --with-nettle )
		fi
		if use mbedtls || use curl_ssl_mbedtls; then
			einfo "SSL provided by mbedtls"
			myconf+=( --with-mbedtls )
		fi
		if use nss || use curl_ssl_nss; then
			einfo "SSL provided by nss"
			myconf+=( --with-nss --with-nss-deprecated )
		fi
		if use openssl || use curl_ssl_openssl; then
			einfo "SSL provided by openssl"
			myconf+=( --with-ssl --with-ca-path="${EPREFIX}"/etc/ssl/certs )
		fi

		if use curl_ssl_gnutls; then
			einfo "Default SSL provided by gnutls"
			myconf+=( --with-default-ssl-backend=gnutls )
		elif use curl_ssl_mbedtls; then
			einfo "Default SSL provided by mbedtls"
			myconf+=( --with-default-ssl-backend=mbedtls )
		elif use curl_ssl_nss; then
			einfo "Default SSL provided by nss"
			myconf+=( --with-default-ssl-backend=nss )
		elif use curl_ssl_openssl; then
			einfo "Default SSL provided by openssl"
			myconf+=( --with-default-ssl-backend=openssl )
		else
			eerror "We can't be here because of REQUIRED_USE."
		fi

	else
		einfo "SSL disabled"
	fi

	# These configuration options are organized alphabetically
	# within each category.  This should make it easier if we
	# ever decide to make any of them contingent on USE flags:
	# 1) protocols first.  To see them all do
	# 'grep SUPPORT_PROTOCOLS configure.ac'
	# 2) --enable/disable options second.
	# 'grep -- --enable configure | grep Check | awk '{ print $4 }' | sort
	# 3) --with/without options third.
	# grep -- --with configure | grep Check | awk '{ print $4 }' | sort

	myconf+=(
		$(use_enable alt-svc)
		--enable-crypto-auth
		--enable-dict
		--disable-ech
		--enable-file
		$(use_enable ftp)
		$(use_enable gopher)
		$(use_enable hsts)
		--enable-http
		$(use_enable imap)
		$(use_enable ldap)
		$(use_enable ldap ldaps)
		--enable-ntlm
		--disable-ntlm-wb
		$(use_enable pop3)
		--enable-rt
		--enable-rtsp
		$(use_enable samba smb)
		$(use_with ssh libssh2)
		$(use_enable smtp)
		$(use_enable telnet)
		$(use_enable tftp)
		--enable-tls-srp
		$(use_enable adns ares)
		--enable-cookies
		--enable-dateparse
		--enable-dnsshuffle
		--enable-doh
		--enable-symbol-hiding
		--enable-http-auth
		$(use_enable ipv6)
		--enable-largefile
		--enable-manual
		--enable-mime
		--enable-netrc
		$(use_enable progress-meter)
		--enable-proxy
		--disable-sspi
		$(use_enable static-libs static)
		--enable-pthreads
		--enable-threaded-resolver
		--disable-versioned-symbols
		--without-amissl
		--without-bearssl
		$(use_with brotli)
		--without-fish-functions-dir
		$(use_with http2 nghttp2)
		--without-hyper
		$(use_with idn libidn2)
		$(use_with kerberos gssapi "${EPREFIX}"/usr)
		--without-libgsasl
		--without-libpsl
		--without-msh3
		$(use_with nghttp3)
		$(use_with nghttp3 ngtcp2)
		$(use_with quiche)
		$(use_with rtmp librtmp)
		--without-rustls
		--without-schannel
		--without-secure-transport
		--without-winidn
		--without-wolfssl
		--with-zlib
		$(use_with zstd)
	)

	ECONF_SOURCE="${S}" \
	econf "${myconf[@]}"

	if ! multilib_is_native_abi; then
		# avoid building the client
		sed -i -e '/SUBDIRS/s:src::' Makefile || die
		sed -i -e '/SUBDIRS/s:scripts::' Makefile || die
	fi

	# Fix up the pkg-config file to be more robust.
	# https://github.com/curl/curl/issues/864
	local priv=() libs=()
	# We always enable zlib.
	libs+=( "-lz" )
	priv+=( "zlib" )
	if use http2; then
		libs+=( "-lnghttp2" )
		priv+=( "libnghttp2" )
	fi
	if use quiche; then
		libs+=( "-lquiche" )
		priv+=( "quiche" )
	fi
	if use nghttp3; then
		libs+=( "-lnghttp3" "-lngtcp2" )
		priv+=( "libnghttp3" "-libtcp2" )
	fi
	if use ssl && use curl_ssl_openssl; then
		libs+=( "-lssl" "-lcrypto" )
		priv+=( "openssl" )
	fi
	grep -q Requires.private libcurl.pc && die "need to update ebuild"
	libs=$(printf '|%s' "${libs[@]}")
	sed -i -r \
		-e "/^Libs.private/s:(${libs#|})( |$)::g" \
		libcurl.pc || die
	echo "Requires.private: ${priv[*]}" >> libcurl.pc
}

multilib_src_test() {
	# See https://github.com/curl/curl/blob/master/tests/runtests.pl#L5721
	# -n: no valgrind (unreliable in sandbox and doesn't work correctly on all arches)
	# -v: verbose
	# -a: keep going on failure (so we see everything which breaks, not just 1st test)
	# -k: keep test files after completion
	# -am: automake style TAP output
	# -p: print logs if test fails
	# Note: if needed, we can disable tests. See e.g. Fedora's packaging
	# or just read https://github.com/curl/curl/tree/master/tests#run.
	multilib_is_native_abi && emake test TFLAGS="-n -v -a -k -am -p"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
	rm -rf "${ED}"/etc/ || die
}
