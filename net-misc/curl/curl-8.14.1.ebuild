# Copyright 1999-2025 Gentoo Authors
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
	if [[ ${P} == *rc* ]]; then
		CURL_URI="https://curl.se/rc/"
		S="${WORKDIR}/${P//_/-}"
	else
		CURL_URI="https://curl.se/download/"
		KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	fi
	SRC_URI="
		${CURL_URI}${P//_/-}.tar.xz
		verify-sig? ( ${CURL_URI}${P//_/-}.tar.xz.asc )
	"
fi

LICENSE="BSD curl ISC test? ( BSD-4 )"
SLOT="0"
IUSE="+adns +alt-svc brotli debug ech +ftp gnutls gopher +hsts +http2 +http3 +httpsrr idn +imap kerberos ldap"
IUSE+=" mbedtls +openssl +pop3 +psl +quic rtmp rustls samba sasl-scram +smtp ssh ssl static-libs test"
IUSE+=" telnet +tftp +websockets zstd"
# These select the default tls implementation / which quic impl to use
IUSE+=" +curl_quic_openssl curl_quic_ngtcp2 curl_ssl_gnutls curl_ssl_mbedtls +curl_ssl_openssl curl_ssl_rustls"
RESTRICT="!test? ( test )"

# HTTPS RR is technically usable with the threaded resolver, but it still uses c-ares to
# ask for the HTTPS RR record type; if DoH is in use the HTTPS record will be requested
# in addition to A and AAAA records.

# To simplify dependency management in the ebuild we'll require c-ares for HTTPS RR (for now?).
# HTTPS RR in cURL is a dependency for:
# - ECH (requires patched openssl or gnutls currently, enabled with rustls)
# - Fetching the ALPN list which should provide a better HTTP/3 experience.

# Only one default ssl / quic provider can be enabled
# The default provider needs its USE satisfied
# HTTP/3 and MultiSSL are mutually exclusive; it's not clear if MultiSSL offers any benefit at all in the modern day.
# https://github.com/curl/curl/commit/65ece771f4602107d9cdd339dff4b420280a2c2e
REQUIRED_USE="
	ech? ( rustls )
	httpsrr? ( adns )
	quic? (
		^^ (
			curl_quic_openssl
			curl_quic_ngtcp2
		)
		http3
		ssl
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
		!gnutls
		!mbedtls
		!rustls
	)
	curl_quic_ngtcp2? (
		curl_ssl_gnutls
		!mbedtls
		!openssl
		!rustls
	)
	curl_ssl_gnutls? ( gnutls )
	curl_ssl_mbedtls? ( mbedtls )
	curl_ssl_openssl? ( openssl )
	curl_ssl_rustls? ( rustls )
	http3? ( alt-svc httpsrr quic )
"

# cURL's docs and CI/CD are great resources for confirming supported versions
# particulary for fast-moving targets like HTTP/2 and TCP/2 e.g.:
# - https://github.com/curl/curl/blob/master/docs/INTERNALS.md (core dependencies + minimum versions)
# - https://github.com/curl/curl/blob/master/docs/HTTP3.md (example of a feature that moves quickly)
# - https://github.com/curl/curl/blob/master/.github/workflows/http3-linux.yml (CI/CD for TCP/2)
# However 'supported' vs 'works' are two entirely different things; be sane but
# don't be afraid to require a later version.
# ngtcp2 = https://bugs.gentoo.org/912029 - can only build with one tls backend at a time.
RDEPEND="
	>=sys-libs/zlib-1.2.5[${MULTILIB_USEDEP}]
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
	ssh? ( >=net-libs/libssh2-1.2.8[${MULTILIB_USEDEP}] )
	sasl-scram? ( >=net-misc/gsasl-2.2.0[static-libs?,${MULTILIB_USEDEP}] )
	ssl? (
		gnutls? (
			app-misc/ca-certificates
			>=net-libs/gnutls-3.1.10:=[static-libs?,${MULTILIB_USEDEP}]
			dev-libs/nettle:=[${MULTILIB_USEDEP}]
		)
		mbedtls? (
			app-misc/ca-certificates
			net-libs/mbedtls:0=[${MULTILIB_USEDEP}]
		)
		openssl? (
			>=dev-libs/openssl-1.0.2:=[static-libs?,${MULTILIB_USEDEP}]
		)
		rustls? (
			>=net-libs/rustls-ffi-0.15.0:=[${MULTILIB_USEDEP}]
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

DOCS=( README docs/{FEATURES.md,INTERNALS.md,FAQ,BUGS.md,CONTRIBUTE.md} )

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
	"${FILESDIR}/${PN}-prefix-4.patch"
	"${FILESDIR}/${PN}-respect-cflags-3.patch"
)

src_prepare() {
	default

	eprefixify curl-config.in
	eautoreconf
}

# Generates TLS-related configure options based on USE flags.
# Outputs options suitable for appending to a configure options array.
_get_curl_tls_configure_opts() {
	local tls_opts=()

	local backend flag_name
	for backend in gnutls mbedtls openssl rustls; do
		if [[ "$backend" == "openssl" ]]; then
			flag_name="ssl"
			tls_opts+=( "--with-ca-path=${EPREFIX}/etc/ssl/certs")
		else
			flag_name="$backend"
		fi

		if use "$backend"; then
			tls_opts+=( "--with-${flag_name}" )
		else
			# If a single backend is enabled, 'ssl' is required, openssl is the default / fallback
			if ! [[ "$backend" == "openssl" ]]; then
				tls_opts+=( "--without-${flag_name}" )
			fi
		fi
	done

	if use curl_ssl_gnutls; then
		multilib_is_native_abi && einfo "Default TLS backend: gnutls"
		tls_opts+=( "--with-default-ssl-backend=gnutls" )
	elif use curl_ssl_mbedtls; then
		multilib_is_native_abi && einfo "Default TLS backend: mbedtls"
		tls_opts+=( "--with-default-ssl-backend=mbedtls" )
	elif use curl_ssl_openssl; then
		multilib_is_native_abi && einfo "Default TLS backend: openssl"
		tls_opts+=( "--with-default-ssl-backend=openssl" )
	elif use curl_ssl_rustls; then
		multilib_is_native_abi && einfo "Default TLS backend: rustls"
		tls_opts+=( "--with-default-ssl-backend=rustls" )
	else
		eerror "We can't be here because of REQUIRED_USE."
		die "Please file a bug, hit impossible condition w/ USE=ssl handling."
	fi

	# Explicitly Disable unimplemented b
	tls_opts+=(
		--without-amissl
		--without-bearssl
		--without-wolfssl
	)

	printf "%s\n" "${tls_opts[@]}"
}

multilib_src_configure() {
	# We make use of the fact that later flags override earlier ones
	# So start with all ssl providers off until proven otherwise
	# TODO: in the future, we may want to add wolfssl (https://www.wolfssl.com/)
	local myconf=()

	myconf+=( --without-ca-fallback --with-ca-bundle="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt  )
	if use ssl; then
		local -a tls_backend_opts
		readarray -t tls_backend_opts < <(_get_curl_tls_configure_opts)
		myconf+=("${tls_backend_opts[@]}")
		if use quic; then
			myconf+=(
				$(use_with curl_quic_ngtcp2 ngtcp2)
				$(use_with curl_quic_openssl openssl-quic)
			)
		else
			# Without a REQUIRED_USE to ensure that QUIC was requested when at least one default backend is
			# enabled we need ensure that we don't try to build QUIC support
			myconf+=( --without-ngtcp2 --without-openssl-quic )
		fi
	else
		myconf+=( --without-ssl )
		einfo "SSL disabled"
	fi

	# These configuration options are organised alphabetically by category/type

	# Protocols
	# `grep SUPPORT_PROTOCOLS=\" configure.ac | awk '{ print substr($2, 1, length($2)-1)}' | sort`
	# Assume that anything omitted (that is not new!) is enabled by default with no deps
	myconf+=(
		--enable-file
		$(use_enable ftp)
		$(use_enable gopher)
		--enable-http
		$(use_enable imap) # Automatic IMAPS if TLS is enabled
		$(use_enable ldap ldaps)
		$(use_enable ldap)
		$(use_enable pop3)
		$(use_enable samba smb)
		$(use_with ssh libssh2) # enables scp/sftp
		$(use_with rtmp librtmp)
		--enable-rtsp
		$(use_enable smtp)
		$(use_enable telnet)
		$(use_enable tftp)
		$(use_enable websockets)
	)

	# Keep various 'HTTP-flavoured' options together
	myconf+=(
		$(use_enable alt-svc)
		$(use_enable hsts)
		$(use_enable httpsrr)
		$(use_with http2 nghttp2)
		$(use_with http3 nghttp3)
	)

	# --enable/disable options
	# `grep -- --enable configure | grep Check | awk '{ print $4 }' | sort`
	myconf+=(
		$(use_enable adns ares)
		--enable-aws
		--enable-basic-auth
		--enable-bearer-auth
		--enable-cookies
		--enable-dateparse
		--enable-dict
		--enable-digest-auth
		--enable-dnsshuffle
		--enable-doh
		$(use_enable ech)
		--enable-http-auth
		--enable-ipv6
		--enable-kerberos-auth
		--enable-largefile
		--enable-manual
		--enable-mime
		--enable-negotiate-auth
		--enable-netrc
		--enable-ntlm
		--enable-progress-meter
		--enable-proxy
		--enable-rt
		--enable-socketpair
		--disable-sspi
		$(use_enable static-libs static)
		--enable-symbol-hiding
		--enable-tls-srp
		--disable-versioned-symbols
	)

	# --with/without options
	# `grep -- --with configure | grep Check | awk '{ print $4 }' | sort`
	myconf+=(
		$(use_with brotli)
		--with-fish-functions-dir="${EPREFIX}"/usr/share/fish/vendor_completions.d
		$(use_with idn libidn2)
		$(use_with kerberos gssapi "${EPREFIX}"/usr)
		$(use_with sasl-scram libgsasl)
		$(use_with psl libpsl)
		--without-msh3
		--without-quiche
		--without-schannel
		--without-secure-transport
		--without-winidn
		--with-zlib
		--with-zsh-functions-dir="${EPREFIX}"/usr/share/zsh/site-functions
		$(use_with zstd)
	)

	# Test deps (disabled)
	myconf+=(
		--without-test-caddy
		--without-test-httpd
		--without-test-nghttpx
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

	# Since 8.12.0 adns/c-ares and the threaded resolver are mutually exclusive
	# This is in support of some work to enable `httpsrr` to use adns and the rest
	# of curl to use the threaded resolver; for us `httpsrr` is conditional on adns.
	if use adns; then
		myconf+=(
			--disable-threaded-resolver
		)
	else
		myconf+=(
			--enable-threaded-resolver
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
	# -a: keep going on failure (so we see everything that breaks, not just 1st test)
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
