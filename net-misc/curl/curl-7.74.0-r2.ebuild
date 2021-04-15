# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools prefix multilib-minimal

DESCRIPTION="A Client that groks URLs"
HOMEPAGE="https://curl.haxx.se/"
SRC_URI="https://curl.haxx.se/download/${P}.tar.xz"

LICENSE="curl"
SLOT="0"
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="adns alt-svc brotli +ftp gnutls gopher hsts +http2 idn +imap ipv6 kerberos ldap libressl mbedtls metalink nss +openssl +pop3 +progress-meter rtmp samba +smtp ssh ssl static-libs test telnet +tftp threads winssl zstd"
IUSE+=" curl_ssl_gnutls curl_ssl_libressl curl_ssl_mbedtls curl_ssl_nss +curl_ssl_openssl curl_ssl_winssl"
IUSE+=" nghttp3 quiche"
IUSE+=" elibc_Winnt"

#lead to lots of false negatives, bug #285669
RESTRICT="!test? ( test )"

RDEPEND="ldap? ( net-nds/openldap[${MULTILIB_USEDEP}] )
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
			!libressl? ( dev-libs/openssl:0=[static-libs?,${MULTILIB_USEDEP}] )
			libressl? ( dev-libs/libressl:0=[static-libs?,${MULTILIB_USEDEP}] )
		)
		nss? (
			dev-libs/nss:0[${MULTILIB_USEDEP}]
			app-misc/ca-certificates
		)
	)
	http2? ( net-libs/nghttp2[${MULTILIB_USEDEP}] )
	nghttp3? (
		net-libs/nghttp3[${MULTILIB_USEDEP}]
		net-libs/ngtcp2[ssl,${MULTILIB_USEDEP}]
	)
	quiche? ( >=net-libs/quiche-0.3.0[${MULTILIB_USEDEP}] )
	idn? ( net-dns/libidn2:0=[static-libs?,${MULTILIB_USEDEP}] )
	adns? ( net-dns/c-ares:0[${MULTILIB_USEDEP}] )
	kerberos? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
	metalink? ( >=media-libs/libmetalink-0.1.1[${MULTILIB_USEDEP}] )
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

# ssl providers to be added:
# fbopenssl  $(use_with spnego)

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	test? (
		sys-apps/diffutils
		dev-lang/perl
	)"

# c-ares must be disabled for threads
# only one default ssl provider can be enabled
REQUIRED_USE="
	winssl? ( elibc_Winnt )
	threads? ( !adns )
	ssl? (
		^^ (
			curl_ssl_gnutls
			curl_ssl_libressl
			curl_ssl_mbedtls
			curl_ssl_nss
			curl_ssl_openssl
			curl_ssl_winssl
		)
	)"

DOCS=( CHANGES README docs/FEATURES.md docs/INTERNALS.md \
	docs/FAQ docs/BUGS.md docs/CONTRIBUTE.md )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/curl/curlbuild.h
)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/curl-config
)

src_prepare() {
	eapply "${FILESDIR}"/${PN}-7.30.0-prefix.patch
	eapply "${FILESDIR}"/${PN}-respect-cflags-3.patch
	eapply "${FILESDIR}"/${PN}-fix-gnutls-nettle.patch

	sed -i '/LD_LIBRARY_PATH=/d' configure.ac || die #382241
	sed -i '/CURL_MAC_CFLAGS/d' configure.ac || die #637252

	eapply_user
	eprefixify curl-config.in
	eautoreconf
}

multilib_src_configure() {
	# We make use of the fact that later flags override earlier ones
	# So start with all ssl providers off until proven otherwise
	# TODO: in the future, we may want to add wolfssl (https://www.wolfssl.com/)
	local myconf=()

	myconf+=( --without-gnutls --without-mbedtls --without-nss --without-polarssl --without-ssl --without-winssl )
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
			myconf+=( --with-nss )
		fi
		if use openssl || use curl_ssl_openssl || use curl_ssl_libressl; then
			einfo "SSL provided by openssl"
			myconf+=( --with-ssl --with-ca-path="${EPREFIX}"/etc/ssl/certs )
		fi
		if use winssl || use curl_ssl_winssl; then
			einfo "SSL provided by Windows"
			myconf+=( --with-winssl )
		fi

		if use curl_ssl_gnutls; then
			einfo "Default SSL provided by gnutls"
			myconf+=( --with-default-ssl-backend=gnutls )
		elif use curl_ssl_libressl; then
			einfo "Default SSL provided by LibreSSL"
			myconf+=( --with-default-ssl-backend=openssl )  # NOTE THE HACK HERE
		elif use curl_ssl_mbedtls; then
			einfo "Default SSL provided by mbedtls"
			myconf+=( --with-default-ssl-backend=mbedtls )
		elif use curl_ssl_nss; then
			einfo "Default SSL provided by nss"
			myconf+=( --with-default-ssl-backend=nss )
		elif use curl_ssl_openssl; then
			einfo "Default SSL provided by openssl"
			myconf+=( --with-default-ssl-backend=openssl )
		elif use curl_ssl_winssl; then
			einfo "Default SSL provided by Windows"
			myconf+=( --with-default-ssl-backend=winssl )
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

	ECONF_SOURCE="${S}" \
	econf \
		$(use_enable alt-svc) \
		--enable-crypto-auth \
		--enable-dict \
		--disable-ech \
		--enable-file \
		$(use_enable ftp) \
		$(use_enable gopher) \
		$(use_enable hsts) \
		--enable-http \
		$(use_enable imap) \
		$(use_enable ldap) \
		$(use_enable ldap ldaps) \
		--disable-ntlm-wb \
		$(use_enable pop3) \
		--enable-rt  \
		--enable-rtsp \
		$(use_enable samba smb) \
		$(use_with ssh libssh2) \
		$(use_enable smtp) \
		$(use_enable telnet) \
		$(use_enable tftp) \
		--enable-tls-srp \
		$(use_enable adns ares) \
		--enable-cookies \
		--enable-dateparse \
		--enable-dnsshuffle \
		--enable-doh \
		--enable-hidden-symbols \
		--enable-http-auth \
		$(use_enable ipv6) \
		--enable-largefile \
		--enable-manual \
		--enable-mime \
		--enable-netrc \
		$(use_enable progress-meter) \
		--enable-proxy \
		--disable-sspi \
		$(use_enable static-libs static) \
		$(use_enable threads threaded-resolver) \
		$(use_enable threads pthreads) \
		--disable-versioned-symbols \
		--without-amissl \
		--without-bearssl \
		--without-cyassl \
		--without-darwinssl \
		--without-fish-functions-dir \
		$(use_with idn libidn2) \
		$(use_with kerberos gssapi "${EPREFIX}"/usr) \
		$(use_with metalink libmetalink) \
		$(use_with http2 nghttp2) \
		--without-libpsl \
		$(use_with nghttp3) \
		$(use_with nghttp3 ngtcp2) \
		$(use_with quiche) \
		$(use_with rtmp librtmp) \
		$(use_with brotli) \
		--without-schannel \
		--without-secure-transport \
		--without-spnego \
		--without-winidn \
		--without-wolfssl \
		--with-zlib \
		$(use_with zstd) \
		"${myconf[@]}"

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

multilib_src_install_all() {
	default
	find "${ED}" -type f -name '*.la' -delete
	rm -rf "${ED}"/etc/
}
