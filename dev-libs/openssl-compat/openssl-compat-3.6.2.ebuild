# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/openssl.org.asc

inherit edo flag-o-matic toolchain-funcs multilib-minimal verify-sig

MY_P=openssl-${PV/_/-}

DESCRIPTION="Full-strength general purpose cryptography library (including SSL and TLS)"
HOMEPAGE="https://openssl-library.org/"
SRC_URI="
	https://github.com/openssl/openssl/releases/download/${MY_P}/${MY_P}.tar.gz
	verify-sig? (
		https://github.com/openssl/openssl/releases/download/${MY_P}/${MY_P}.tar.gz.asc
	)
"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="+asm cpu_flags_x86_sse2 +quic rfc3779 sctp test tls-compression vanilla weak-ssl-ciphers"
RESTRICT="!test? ( test )"

RDEPEND="
	!=dev-libs/openssl-$(ver_cut 1)*:0
	tls-compression? ( >=virtual/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-lang/perl-5
	sctp? ( >=net-misc/lksctp-tools-1.0.12 )
	test? (
		sys-apps/diffutils
		app-alternatives/bc
		sys-process/procps
	)
	verify-sig? ( >=sec-keys/openpgp-keys-openssl-20240920 )
"

# Do not install any docs
DOCS=()

pkg_setup() {
	[[ ${MERGE_TYPE} == binary ]] && return

	# must check in pkg_setup; sysctl doesn't work with userpriv!
	if use test && use sctp ; then
		# test_ssl_new will fail with "Ensure SCTP AUTH chunks are enabled in kernel"
		# if sctp.auth_enable is not enabled.
		local sctp_auth_status=$(sysctl -n net.sctp.auth_enable 2>/dev/null)
		if [[ -z "${sctp_auth_status}" ]] || [[ ${sctp_auth_status} != 1 ]] ; then
			die "FEATURES=test with USE=sctp requires net.sctp.auth_enable=1!"
		fi
	fi
}

src_prepare() {
	# Keep this in sync with app-misc/c_rehash
	SSL_CNF_DIR="/etc/ssl"

	# Make sure we only ever touch Makefile.org and avoid patching a file
	# that gets blown away anyways by the Configure script in src_configure
	rm -f Makefile || die

	if ! use vanilla ; then
		PATCHES+=(
			# Add patches which are Gentoo-specific customisations here
		)
	fi

	default

	if use test && use sctp && has network-sandbox ${FEATURES} ; then
		einfo "Disabling test '80-test_ssl_new.t' which is known to fail with FEATURES=network-sandbox ..."
		rm test/recipes/80-test_ssl_new.t || die
	fi

	# Test fails depending on kernel configuration, bug #699134
	rm test/recipes/30-test_afalg.t || die

	# Quiet out unknown driver argument warnings since openssl
	# doesn't have well-split CFLAGS and we're making it even worse
	# and 'make depend' uses -Werror for added fun (bug #417795 again)
	tc-is-clang && append-flags -Qunused-arguments

	# We really, really need to build OpenSSL w/ strict aliasing disabled.
	# It's filled with violations and it *will* result in miscompiled
	# code. This has been in the ebuild for > 10 years but even in 2022,
	# it's still relevant:
	# - https://github.com/llvm/llvm-project/issues/55255
	# - https://github.com/openssl/openssl/issues/12247
	# - https://github.com/openssl/openssl/issues/18225
	# - https://github.com/openssl/openssl/issues/18663#issuecomment-1181478057
	# Don't remove the no strict aliasing bits below!
	filter-flags -fstrict-aliasing
	append-flags -fno-strict-aliasing
	# The OpenSSL developers don't test with LTO right now, it leads to various
	# warnings/errors (which may or may not be false positives), it's considered
	# unsupported, and it's not tested in CI: https://github.com/openssl/openssl/issues/18663.
	filter-lto

	append-flags $(test-flags-CC -Wa,--noexecstack)

	# bug #895308 -- check inserts GNU ld-compatible arguments
	[[ ${CHOST} == *-darwin* ]] || append-atomic-flags
	# Configure doesn't respect LIBS
	export LDLIBS="${LIBS}"

	multilib_copy_sources
}

multilib_src_configure() {
	# bug #197996
	unset APPS
	# bug #312551
	unset SCRIPTS
	# bug #311473
	unset CROSS_COMPILE

	tc-export AR CC CXX RANLIB RC

	use_ssl() { usex $1 "enable-${2:-$1}" "no-${2:-$1}" " ${*:3}" ; }

	local sslout=$(bash "${FILESDIR}/gentoo.config-1.0.4")
	einfo "Using configuration: ${sslout:-(openssl knows best)}"

	# https://github.com/openssl/openssl/blob/master/INSTALL.md#enable-and-disable-features
	local myeconfargs=(
		${sslout}

		no-docs
		$(use cpu_flags_x86_sse2 || echo "no-sse2")
		enable-camellia
		enable-ec
		enable-ec2m
		enable-sm2
		enable-srp
		$(use elibc_musl && echo "no-async")
		enable-idea
		enable-mdc2
		enable-rc5
		$(use_ssl asm)
		$(use quic && echo "enable-quic")
		$(use_ssl rfc3779)
		$(use_ssl sctp)
		$(use test || echo "no-tests")
		$(use_ssl tls-compression zlib)
		$(use_ssl weak-ssl-ciphers)

		--prefix="${EPREFIX}/usr"
		--openssldir="${EPREFIX}${SSL_CNF_DIR}"
		--libdir=$(get_libdir)

		shared
		threads
	)

	edo perl Configure "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake build_sw
}

multilib_src_test() {
	emake -j1 test
}

multilib_src_install() {
	dolib.so lib{crypto,ssl}.so.$(ver_cut 1)
}
