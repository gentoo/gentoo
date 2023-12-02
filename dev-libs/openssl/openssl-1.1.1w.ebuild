# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/openssl.org.asc
inherit edo flag-o-matic toolchain-funcs multilib-minimal verify-sig

MY_P=${P/_/-}
DESCRIPTION="Full-strength general purpose cryptography library (including SSL and TLS)"
HOMEPAGE="https://www.openssl.org/"
SRC_URI="mirror://openssl/source/${MY_P}.tar.gz
	verify-sig? ( mirror://openssl/source/${MY_P}.tar.gz.asc )"
S="${WORKDIR}/${MY_P}"

LICENSE="openssl"
SLOT="0/1.1" # .so version of libssl/libcrypto
if [[ ${PV} != *_pre* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi
IUSE="+asm rfc3779 sctp cpu_flags_x86_sse2 sslv3 static-libs test tls-compression tls-heartbeat vanilla verify-sig weak-ssl-ciphers"
RESTRICT="!test? ( test )"

RDEPEND="
	tls-compression? ( >=sys-libs/zlib-1.2.8-r1[static-libs(+)?,${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-lang/perl-5
	sctp? ( >=net-misc/lksctp-tools-1.0.12 )
	test? (
		sys-apps/diffutils
		sys-devel/bc
		kernel_linux? ( sys-process/procps )
	)
	verify-sig? ( >=sec-keys/openpgp-keys-openssl-20230801 )"
PDEPEND="app-misc/ca-certificates"

# force upgrade to prevent broken login, bug #696950
RDEPEND+=" !<net-misc/openssh-8.0_p1-r3"

MULTILIB_WRAPPED_HEADERS=(
	usr/include/openssl/opensslconf.h
)

PATCHES=(
	# General patches which are suitable to always apply
	# If they're Gentoo specific, add to USE=-vanilla logic in src_prepare!
	"${FILESDIR}"/${PN}-1.1.0j-parallel_install_fix.patch # bug #671602
	"${FILESDIR}"/${PN}-1.1.1i-riscv32.patch
)

pkg_setup() {
	[[ ${MERGE_TYPE} == binary ]] && return

	# must check in pkg_setup; sysctl doesn't work with userpriv!
	if use test && use sctp; then
		# test_ssl_new will fail with "Ensure SCTP AUTH chunks are enabled in kernel"
		# if sctp.auth_enable is not enabled.
		local sctp_auth_status=$(sysctl -n net.sctp.auth_enable 2>/dev/null)
		if [[ -z "${sctp_auth_status}" ]] || [[ ${sctp_auth_status} != 1 ]]; then
			die "FEATURES=test with USE=sctp requires net.sctp.auth_enable=1!"
		fi
	fi
}

src_unpack() {
	# Can delete this once test fix patch is dropped
	if use verify-sig ; then
		# Needed for downloaded patch (which is unsigned, which is fine)
		verify-sig_verify_detached "${DISTDIR}"/${MY_P}.tar.gz{,.asc}
	fi

	default
}

src_prepare() {
	# Make sure we only ever touch Makefile.org and avoid patching a file
	# that gets blown away anyways by the Configure script in src_configure
	rm -f Makefile

	if ! use vanilla ; then
		PATCHES+=(
			# Add patches which are Gentoo-specific customisations here
		)
	fi

	default

	if use test && use sctp && has network-sandbox ${FEATURES}; then
		einfo "Disabling test '80-test_ssl_new.t' which is known to fail with FEATURES=network-sandbox ..."
		rm test/recipes/80-test_ssl_new.t || die
	fi

	# Test fails depending on kernel configuration, bug #699134
	rm test/recipes/30-test_afalg.t || die

	# Remove test target when FEATURES=test isn't set
	if ! use test ; then
		sed \
			-e '/^$config{dirs}/s@ "test",@@' \
			-i Configure || die
	fi

	if use prefix && [[ ${CHOST} == *-solaris* ]] ; then
		# use GNU ld full option, not to confuse it on Solaris
		sed -i \
			-e 's/-Wl,-M,/-Wl,--version-script=/' \
			-e 's/-Wl,-h,/-Wl,--soname=/' \
			Configurations/10-main.conf || die
	fi

	# The config script does stupid stuff to prompt the user.  Kill it.
	sed -i '/stty -icanon min 0 time 50; read waste/d' config || die
}

src_configure() {
	# Keep this in sync with app-misc/c_rehash
	SSL_CNF_DIR="/etc/ssl"

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

	append-cppflags -DOPENSSL_NO_BUF_FREELISTS

	append-flags $(test-flags-CC -Wa,--noexecstack)

	# bug #197996
	unset APPS
	# bug #312551
	unset SCRIPTS
	# bug #311473
	unset CROSS_COMPILE

	tc-export AR CC CXX RANLIB RC

	multilib-minimal_src_configure
}

multilib_src_configure() {
	use_ssl() { usex $1 "enable-${2:-$1}" "no-${2:-$1}" " ${*:3}" ; }

	local krb5=$(has_version app-crypt/mit-krb5 && echo "MIT" || echo "Heimdal")

	# See if our toolchain supports __uint128_t.  If so, it's 64bit
	# friendly and can use the nicely optimized code paths, bug #460790.
	#local ec_nistp_64_gcc_128
	#
	# Disable it for now though (bug #469976)
	# Do NOT re-enable without substantial discussion first!
	#
	#echo "__uint128_t i;" > "${T}"/128.c
	#if ${CC} ${CFLAGS} -c "${T}"/128.c -o /dev/null >&/dev/null ; then
	#	ec_nistp_64_gcc_128="enable-ec_nistp_64_gcc_128"
	#fi

	local sslout=$(bash "${FILESDIR}/gentoo.config-1.0.4")
	einfo "Use configuration ${sslout:-(openssl knows best)}"
	local config=( perl "${S}/Configure" )
	[[ -z ${sslout} ]] && config=( sh "${S}/config" -v )

	# "disable-deprecated" option breaks too many consumers.
	# Don't set it without thorough revdeps testing.
	# Make sure user flags don't get added *yet* to avoid duplicated
	# flags.
	local myeconfargs=(
		${sslout}

		$(use cpu_flags_x86_sse2 || echo "no-sse2")
		enable-camellia
		enable-ec
		enable-ec2m
		enable-sm2
		enable-srp
		$(use elibc_musl && echo "no-async")
		${ec_nistp_64_gcc_128}
		enable-idea
		enable-mdc2
		enable-rc5
		$(use_ssl sslv3 ssl3)
		$(use_ssl sslv3 ssl3-method)
		$(use_ssl asm)
		$(use_ssl rfc3779)
		$(use_ssl sctp)
		$(use test || echo "no-tests")
		$(use_ssl tls-compression zlib)
		$(use_ssl tls-heartbeat heartbeats)
		$(use_ssl weak-ssl-ciphers)

		--prefix="${EPREFIX}"/usr
		--openssldir="${EPREFIX}"${SSL_CNF_DIR}
		--libdir=$(get_libdir)

		shared
		threads
	)

	edo "${config[@]}" "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake all
}

multilib_src_test() {
	emake -j1 test
}

multilib_src_install() {
	# Only -j1 is supported for the install targets:
	# https://github.com/openssl/openssl/issues/21999#issuecomment-1771150305
	emake DESTDIR="${D}" -j1 install_sw

	if multilib_is_native_abi; then
		emake DESTDIR="${D}" -j1 install_ssldirs
		emake DESTDIR="${D}" DOCDIR='$(INSTALLTOP)'/share/doc/${PF} MANSUFFIX=ssl -j1 install_docs
	fi

	# This is crappy in that the static archives are still built even
	# when USE=static-libs. But this is due to a failing in the openssl
	# build system: the static archives are built as PIC all the time.
	# Only way around this would be to manually configure+compile openssl
	# twice; once with shared lib support enabled and once without.
	if ! use static-libs; then
		rm "${ED}"/usr/$(get_libdir)/lib{crypto,ssl}.a || die
	fi
}

multilib_src_install_all() {
	# openssl installs perl version of c_rehash by default, but
	# we provide a shell version via app-misc/c_rehash
	rm "${ED}"/usr/bin/c_rehash || die

	dodoc CHANGES* FAQ NEWS README doc/*.txt doc/${PN}-c-indent.el

	# Create the certs directory
	keepdir ${SSL_CNF_DIR}/certs

	# bug #254521
	dodir /etc/sandbox.d
	echo 'SANDBOX_PREDICT="/dev/crypto"' > "${ED}"/etc/sandbox.d/10openssl

	diropts -m0700
	keepdir ${SSL_CNF_DIR}/private
}

pkg_postinst() {
	ebegin "Running 'openssl rehash ${EROOT}${SSL_CNF_DIR}/certs' to rebuild hashes (bug #333069)"
	openssl rehash "${EROOT}${SSL_CNF_DIR}/certs"
	eend $?
}
