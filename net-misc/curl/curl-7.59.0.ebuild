# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools eutils prefix multilib-minimal

DESCRIPTION="A Client that groks URLs"
HOMEPAGE="https://curl.haxx.se/"
SRC_URI="https://curl.haxx.se/download/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="adns brotli http2 idn ipv6 kerberos ldap metalink rtmp samba ssh ssl static-libs test threads"
IUSE+=" curl_ssl_axtls curl_ssl_gnutls curl_ssl_libressl curl_ssl_mbedtls curl_ssl_nss +curl_ssl_openssl curl_ssl_winssl"
IUSE+=" elibc_Winnt"

#lead to lots of false negatives, bug #285669
RESTRICT="test"

RDEPEND="ldap? ( net-nds/openldap[${MULTILIB_USEDEP}] )
	brotli? ( app-arch/brotli:= )
	ssl? (
		curl_ssl_axtls? (
			net-libs/axtls:0=[${MULTILIB_USEDEP}]
			app-misc/ca-certificates
		)
		curl_ssl_gnutls? (
			net-libs/gnutls:0=[static-libs?,${MULTILIB_USEDEP}]
			dev-libs/nettle:0=[${MULTILIB_USEDEP}]
			app-misc/ca-certificates
		)
		curl_ssl_libressl? (
			dev-libs/libressl:0=[static-libs?,${MULTILIB_USEDEP}]
		)
		curl_ssl_mbedtls? (
			net-libs/mbedtls:0=[${MULTILIB_USEDEP}]
			app-misc/ca-certificates
		)
		curl_ssl_openssl? (
			dev-libs/openssl:0=[static-libs?,${MULTILIB_USEDEP}]
		)
		curl_ssl_nss? (
			dev-libs/nss:0[${MULTILIB_USEDEP}]
			app-misc/ca-certificates
		)
	)
	http2? ( net-libs/nghttp2[${MULTILIB_USEDEP}] )
	idn? ( net-dns/libidn2:0[static-libs?,${MULTILIB_USEDEP}] )
	adns? ( net-dns/c-ares:0[${MULTILIB_USEDEP}] )
	kerberos? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
	metalink? ( >=media-libs/libmetalink-0.1.1[${MULTILIB_USEDEP}] )
	rtmp? ( media-video/rtmpdump[${MULTILIB_USEDEP}] )
	ssh? ( net-libs/libssh2[static-libs?,${MULTILIB_USEDEP}] )
	sys-libs/zlib[${MULTILIB_USEDEP}]
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
			curl_ssl_mbedtls
			curl_ssl_nss
			curl_ssl_openssl
			curl_ssl_winssl
		)
	)"

DOCS=( CHANGES README docs/FEATURES docs/INTERNALS.md \
	docs/MANUAL docs/FAQ docs/BUGS docs/CONTRIBUTE.md )

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

	eapply_user
	eprefixify curl-config.in
	eautoreconf

	if [[ ${CHOST} == *-darwin17 ]] ; then
		# https://bugs.gentoo.org/show_bug.cgi?id=637252
		sed -i -e '/-Werror=partial-availability/s/Werror/Wno-error/g' \
			configure || die
	fi
}

multilib_src_configure() {
	# We make use of the fact that later flags override earlier ones
	# So start with all ssl providers off until proven otherwise
	local myconf=()
	myconf+=( --without-axtls --without-gnutls --without-mbedtls --without-nss --without-polarssl --without-ssl --without-winssl )
	myconf+=( --without-ca-fallback --with-ca-bundle="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt  )
	if use ssl ; then
		if use curl_ssl_axtls; then
			einfo "SSL provided by axtls"
			myconf+=( --with-axtls )
		elif use curl_ssl_gnutls; then
			einfo "SSL provided by gnutls"
			myconf+=( --with-gnutls --with-nettle )
		elif use curl_ssl_libressl; then
			einfo "SSL provided by LibreSSL"
			myconf+=( --with-ssl --with-ca-path="${EPREFIX}"/etc/ssl/certs )
		elif use curl_ssl_mbedtls; then
			einfo "SSL provided by mbedtls"
			myconf+=( --with-mbedtls )
		elif use curl_ssl_nss; then
			einfo "SSL provided by nss"
			myconf+=( --with-nss )
		elif use curl_ssl_openssl; then
			einfo "SSL provided by openssl"
			myconf+=( --with-ssl --with-ca-path="${EPREFIX}"/etc/ssl/certs )
		elif use curl_ssl_winssl; then
			einfo "SSL provided by Windows"
			myconf+=( --with-winssl )
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
		--enable-crypto-auth \
		--enable-dict \
		--enable-file \
		--enable-ftp \
		--enable-gopher \
		--enable-http \
		--enable-imap \
		$(use_enable ldap) \
		$(use_enable ldap ldaps) \
		--disable-ntlm-wb \
		--enable-pop3 \
		--enable-rt  \
		--enable-rtsp \
		$(use_enable samba smb) \
		$(use_with ssh libssh2) \
		--enable-smtp \
		--enable-telnet \
		--enable-tftp \
		--enable-tls-srp \
		$(use_enable adns ares) \
		--enable-cookies \
		--enable-hidden-symbols \
		$(use_enable ipv6) \
		--enable-largefile \
		--without-libpsl \
		--enable-manual \
		--enable-proxy \
		--disable-sspi \
		$(use_enable static-libs static) \
		$(use_enable threads threaded-resolver) \
		$(use_enable threads pthreads) \
		--disable-versioned-symbols \
		--without-cyassl \
		--without-darwinssl \
		$(use_with idn libidn2) \
		$(use_with kerberos gssapi "${EPREFIX}"/usr) \
		$(use_with metalink libmetalink) \
		$(use_with http2 nghttp2) \
		$(use_with rtmp librtmp) \
		$(use_with brotli) \
		--without-spnego \
		--without-winidn \
		--with-zlib \
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
	if use curl_ssl_openssl; then
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
	einstalldocs
	prune_libtool_files --all

	rm -rf "${ED}"/etc/
}
