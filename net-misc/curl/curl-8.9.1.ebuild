# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Maintainers should subscribe to the 'curl-distros' ML for backports etc
# https://daniel.haxx.se/blog/2024/03/25/curl-distro-report/
# https://lists.haxx.se/listinfo/curl-distros

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/danielstenberg.asc
inherit autotools multilib-minimal multiprocessing prefix toolchain-funcs verify-sig

DESCRIPTION="A Client that groks URLs"
HOMEPAGE="https://curl.se/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/curl/curl.git"
else
	SRC_URI="
		https://curl.se/download/${P}.tar.xz
		verify-sig? ( https://curl.se/download/${P}.tar.xz.asc )
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

LICENSE="BSD curl ISC test? ( BSD-4 )"
SLOT="0"
IUSE="+adns +alt-svc brotli debug +ftp gnutls gopher +hsts +http2 +http3 idn +imap kerberos ldap mbedtls +openssl +pop3"
IUSE+=" +psl +progress-meter +quic rtmp rustls samba +smtp ssh ssl sslv3 static-libs test telnet +tftp websockets zstd"
# These select the default tls implementation / which quic impl to use
IUSE+=" +curl_quic_openssl curl_quic_ngtcp2 curl_ssl_gnutls curl_ssl_mbedtls +curl_ssl_openssl curl_ssl_rustls"
RESTRICT="!test? ( test )"

# Only one default ssl / quic provider can be enabled
# The default provider needs its USE satisfied
# HTTP/3 and MultiSSL are mutually exclusive; it's not clear if MultiSSL offers any benefit at all in the modern day.
# https://github.com/curl/curl/commit/65ece771f4602107d9cdd339dff4b420280a2c2e
REQUIRED_USE="
	quic? (
		^^ (
			curl_quic_openssl
			curl_quic_ngtcp2
		)
		http3
	)
	ssl? (
		^^ (
			curl_ssl_gnutls
			curl_ssl_mbedtls
			curl_ssl_openssl
			curl_ssl_rustls
		)
	)
	curl_quic_openssl? (
		curl_ssl_openssl
		quic
		!gnutls
		!mbedtls
		!rustls
	)
	curl_quic_ngtcp2? (
		curl_ssl_gnutls
		quic
		!mbedtls
		!openssl
		!rustls
	)
	curl_ssl_gnutls? ( gnutls )
	curl_ssl_mbedtls? ( mbedtls )
	curl_ssl_openssl? ( openssl )
	curl_ssl_rustls? ( rustls )
	http3? ( alt-svc quic )
"

# cURL's docs and CI/CD are great resources for confirming supported versions
# particulary for fast-moving targets like HTTP/2 and TCP/2 e.g.:
# - https://github.com/curl/curl/blob/master/docs/INTERNALS.md (core dependencies + minimum versions)
# - https://github.com/curl/curl/blob/master/docs/HTTP3.md (example of a feature that moves quickly)
# - https://github.com/curl/curl/blob/master/.github/workflows/quiche-linux.yml (CI/CD for TCP/2)
# However 'supported' vs 'works' are two entirely different things; be sane but
# don't be afraid to require a later version.
# ngtcp2 = https://bugs.gentoo.org/912029 - can only build with one tls backend at a time.
RDEPEND="
	>=sys-libs/zlib-1.1.4[${MULTILIB_USEDEP}]
	adns? ( >=net-dns/c-ares-1.16.0:=[${MULTILIB_USEDEP}] )
	brotli? ( app-arch/brotli:=[${MULTILIB_USEDEP}] )
	http2? ( >=net-libs/nghttp2-1.15.0:=[${MULTILIB_USEDEP}] )
	http3? ( >=net-libs/nghttp3-1.1.0[${MULTILIB_USEDEP}] )
	idn? ( >=net-dns/libidn2-2.0.0:=[static-libs?,${MULTILIB_USEDEP}] )
	kerberos? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
	ldap? ( >=net-nds/openldap-2.0.0:=[static-libs?,${MULTILIB_USEDEP}] )
	psl? ( net-libs/libpsl[${MULTILIB_USEDEP}] )
	quic? (
		curl_quic_openssl? ( >=dev-libs/openssl-3.3.0:=[quic,${MULTILIB_USEDEP}] )
		curl_quic_ngtcp2? ( >=net-libs/ngtcp2-1.2.0[gnutls,ssl,-openssl,${MULTILIB_USEDEP}] )
	)
	rtmp? ( media-video/rtmpdump[${MULTILIB_USEDEP}] )
	ssh? ( >=net-libs/libssh2-1.0.0[${MULTILIB_USEDEP}] )
	ssl? (
		gnutls? (
			app-misc/ca-certificates
			>=net-libs/gnutls-3.1.10:=[static-libs?,${MULTILIB_USEDEP}]
			dev-libs/nettle:=[${MULTILIB_USEDEP}]
		)
		mbedtls? (
			app-misc/ca-certificates
			net-libs/mbedtls:=[${MULTILIB_USEDEP}]
		)
		openssl? (
			>=dev-libs/openssl-0.9.7:=[sslv3(-)=,static-libs?,${MULTILIB_USEDEP}]
		)
		rustls? (
			>=net-libs/rustls-ffi-0.13.0:=[${MULTILIB_USEDEP}]
		)
	)
	zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )
"

DEPEND="${RDEPEND}"

BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
	test? (
		sys-apps/diffutils
		http2? ( >=net-libs/nghttp2-1.15.0:=[utils,${MULTILIB_USEDEP}] )
		http3? ( net-libs/nghttp2:=[utils,${MULTILIB_USEDEP}] )
	)
	verify-sig? ( sec-keys/openpgp-keys-danielstenberg )
"

DOCS=( CHANGES README docs/{FEATURES.md,INTERNALS.md,FAQ,BUGS.md,CONTRIBUTE.md} )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/curl/curlbuild.h
)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/curl-config
)

QA_CONFIG_IMPL_DECL_SKIP=(
	__builtin_available
	closesocket
	CloseSocket
	getpass_r
	ioctlsocket
	IoctlSocket
	mach_absolute_time
	setmode
	_fseeki64
	# custom AC_LINK_IFELSE code fails to link even without -Werror
	OSSL_QUIC_client_method
)

PATCHES=(
	"${FILESDIR}"/${PN}-prefix-2.patch
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

	myconf+=( --without-ca-fallback --with-ca-bundle="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt  )
	if use ssl; then
		myconf+=( --without-gnutls --without-mbedtls --without-rustls )

		if use gnutls; then
			multilib_is_native_abi && einfo "SSL provided by gnutls"
			myconf+=( --with-gnutls )
		fi
		if use mbedtls; then
			multilib_is_native_abi && einfo "SSL provided by mbedtls"
			myconf+=( --with-mbedtls )
		fi
		if use openssl; then
			multilib_is_native_abi && einfo "SSL provided by openssl"
			myconf+=( --with-ssl --with-ca-path="${EPREFIX}"/etc/ssl/certs )
		fi
		if use rustls; then
			multilib_is_native_abi && einfo "SSL provided by rustls"
			myconf+=( --with-rustls )
		fi
		if use curl_ssl_gnutls; then
			multilib_is_native_abi && einfo "Default SSL provided by gnutls"
			myconf+=( --with-default-ssl-backend=gnutls )
		elif use curl_ssl_mbedtls; then
			multilib_is_native_abi && einfo "Default SSL provided by mbedtls"
			myconf+=( --with-default-ssl-backend=mbedtls )
		elif use curl_ssl_openssl; then
			multilib_is_native_abi && einfo "Default SSL provided by openssl"
			myconf+=( --with-default-ssl-backend=openssl )
		elif use curl_ssl_rustls; then
			multilib_is_native_abi && einfo "Default SSL provided by rustls"
			myconf+=( --with-default-ssl-backend=rustls )
		else
			eerror "We can't be here because of REQUIRED_USE."
			die "Please file a bug, hit impossible condition w/ USE=ssl handling."
		fi

	else
		myconf+=( --without-ssl )
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
		--enable-basic-auth
		--enable-bearer-auth
		--enable-digest-auth
		--enable-kerberos-auth
		--enable-negotiate-auth
		--enable-aws
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
		--enable-ipv6
		--enable-largefile
		--enable-manual
		--enable-mime
		--enable-netrc
		$(use_enable progress-meter)
		--enable-proxy
		--enable-socketpair
		--disable-sspi
		$(use_enable static-libs static)
		--enable-pthreads
		--enable-threaded-resolver
		--disable-versioned-symbols
		--without-amissl
		--without-bearssl
		$(use_with brotli)
		--with-fish-functions-dir="${EPREFIX}"/usr/share/fish/vendor_completions.d
		$(use_with http2 nghttp2)
		--without-hyper
		$(use_with idn libidn2)
		$(use_with kerberos gssapi "${EPREFIX}"/usr)
		--without-libgsasl
		$(use_with psl libpsl)
		--without-msh3
		$(use_with http3 nghttp3)
		$(use_with curl_quic_ngtcp2 ngtcp2)
		$(use_with curl_quic_openssl openssl-quic)
		--without-quiche
		$(use_with rtmp librtmp)
		--without-schannel
		--without-secure-transport
		--without-test-caddy
		--without-test-httpd
		--without-test-nghttpx
		$(use_enable websockets)
		--without-winidn
		--without-wolfssl
		--with-zlib
		$(use_with zstd)
		--with-zsh-functions-dir="${EPREFIX}"/usr/share/zsh/site-functions
	)

	if use debug; then
		myconf+=(
			--enable-debug
		)
	fi

	if use test && multilib_is_native_abi && ( use http2 || use http3 ); then
		myconf+=(
			--with-test-nghttpx="${BROOT}/usr/bin/nghttpx"
		)
	fi

	if [[ ${CHOST} == *mingw* ]] ; then
		myconf+=(
			--disable-pthreads
		)
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"

	if ! multilib_is_native_abi; then
		# Avoid building the client (we just want libcurl for multilib)
		sed -i -e '/SUBDIRS/s:src::' Makefile || die
		sed -i -e '/SUBDIRS/s:scripts::' Makefile || die
	fi

}

multilib_src_compile() {
	default

	if multilib_is_native_abi; then
		# Shell completions
		! tc-is-cross-compiler && emake -C scripts
	fi
}

# There is also a pytest harness that tests for bugs in some very specific
# situations; we can rely on upstream for this rather than adding additional test deps.
multilib_src_test() {
	# See https://github.com/curl/curl/blob/master/tests/runtests.pl#L5721
	# -n: no valgrind (unreliable in sandbox and doesn't work correctly on all arches)
	# -v: verbose
	# -a: keep going on failure (so we see everything which breaks, not just 1st test)
	# -k: keep test files after completion
	# -am: automake style TAP output
	# -p: print logs if test fails
	# Note: if needed, we can skip specific tests. See e.g. Fedora's packaging
	# or just read https://github.com/curl/curl/tree/master/tests#run.
	# Note: we don't run the testsuite for cross-compilation.
	# Upstream recommend 7*nproc as a starting point for parallel tests, but
	# this ends up breaking when nproc is huge (like -j80).
	# The network sandbox causes tests 241 and 1083 to fail; these are typically skipped
	# as most gentoo users don't have an 'ip6-localhost'
	multilib_is_native_abi && emake test TFLAGS="-n -v -a -k -am -p -j$((2*$(makeopts_jobs))) !241 !1083"
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi; then
		# Shell completions
		! tc-is-cross-compiler && emake -C scripts DESTDIR="${D}" install
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
	rm -rf "${ED}"/etc/ || die
}

pkg_postinst() {
	if use debug; then
		ewarn "USE=debug has been selected, enabling debug codepaths and making cURL extra verbose."
		ewarn "Use this _only_ for testing. Debug builds should _not_ be used in anger."
		ewarn "hic sunt dracones; you have been warned."
	fi
}
