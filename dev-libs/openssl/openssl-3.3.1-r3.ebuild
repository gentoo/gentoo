# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/openssl.org.asc
inherit edo flag-o-matic linux-info toolchain-funcs
inherit multilib multilib-minimal multiprocessing preserve-libs verify-sig

DESCRIPTION="Robust, full-featured Open Source Toolkit for the Transport Layer Security (TLS)"
HOMEPAGE="https://openssl-library.org/"

MY_P=${P/_/-}

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/openssl/openssl.git"

	inherit git-r3
else
	SRC_URI="
		https://github.com/openssl/openssl/releases/download/${P}/${P}.tar.gz
		verify-sig? (
			https://github.com/openssl/openssl/releases/download/${P}/${P}.tar.gz.asc
		)
	"

	if [[ ${PV} != *_alpha* && ${PV} != *_beta* ]] ; then
		KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	fi
fi

S="${WORKDIR}"/${MY_P}

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1)" # .so version of libssl/libcrypto
IUSE="+asm cpu_flags_x86_sse2 fips ktls +quic rfc3779 sctp static-libs test tls-compression vanilla verify-sig weak-ssl-ciphers"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	!<net-misc/openssh-9.2_p1-r3
	tls-compression? ( >=sys-libs/zlib-1.2.8-r1[static-libs(+)?,${MULTILIB_USEDEP}] )
"
BDEPEND="
	>=dev-lang/perl-5
	sctp? ( >=net-misc/lksctp-tools-1.0.12 )
	test? (
		sys-apps/diffutils
		app-alternatives/bc
		sys-process/procps
	)
	verify-sig? ( >=sec-keys/openpgp-keys-openssl-20240424 )
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
PDEPEND="app-misc/ca-certificates"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/openssl/configuration.h
)

PATCHES=(
	# bug 936311, drop on next version bump
	"${FILESDIR}"/${P}-riscv.patch
	# https://bugs.gentoo.org/936793
	"${FILESDIR}"/openssl-3.3.1-pkg-config.patch
	# https://bugs.gentoo.org/936576
	"${FILESDIR}"/openssl-3.3.1-pkg-config-deux.patch
	# https://bugs.gentoo.org/937457
	"${FILESDIR}"/openssl-3.3.1-cmake-generator.patch
)

pkg_setup() {
	if use ktls ; then
		if kernel_is -lt 4 18 ; then
			ewarn "Kernel implementation of TLS (USE=ktls) requires kernel >=4.18!"
		else
			CONFIG_CHECK="~TLS ~TLS_DEVICE"
			ERROR_TLS="You will be unable to offload TLS to kernel because CONFIG_TLS is not set!"
			ERROR_TLS_DEVICE="You will be unable to offload TLS to kernel because CONFIG_TLS_DEVICE is not set!"
			use test && CONFIG_CHECK+=" ~CRYPTO_USER_API_SKCIPHER"

			linux-info_pkg_setup
		fi
	fi

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

	append-flags $(test-flags-CC -Wa,--noexecstack)

	# bug #895308 -- check inserts GNU ld-compatible arguments
	[[ ${CHOST} == *-darwin* ]] || append-atomic-flags
	# Configure doesn't respect LIBS
	export LDLIBS="${LIBS}"

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
	#       ec_nistp_64_gcc_128="enable-ec_nistp_64_gcc_128"
	#fi

	local sslout=$(bash "${FILESDIR}/gentoo.config-1.0.4")
	einfo "Using configuration: ${sslout:-(openssl knows best)}"

	# https://github.com/openssl/openssl/blob/master/INSTALL.md#enable-and-disable-features
	local myeconfargs=(
		${sslout}

		$(multilib_is_native_abi || echo "no-docs")
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
		$(use fips && echo "enable-fips")
		$(use quic && echo "enable-quic")
		$(use_ssl asm)
		$(use_ssl ktls)
		$(use_ssl rfc3779)
		$(use_ssl sctp)
		$(use test || echo "no-tests")
		$(use_ssl tls-compression zlib)
		$(use_ssl weak-ssl-ciphers)

		--prefix="${EPREFIX}"/usr
		--openssldir="${EPREFIX}"${SSL_CNF_DIR}
		--libdir=$(get_libdir)

		shared
		threads
	)

	edo perl "${S}/Configure" "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake build_sw
}

multilib_src_test() {
	# See https://github.com/openssl/openssl/blob/master/test/README.md for options.
	#
	# VFP = show subtests verbosely and show failed tests verbosely
	# Normal V=1 would show everything verbosely but this slows things down.
	#
	# -j1 here for https://github.com/openssl/openssl/issues/21999, but it
	# shouldn't matter as tests were already built earlier, and HARNESS_JOBS
	# controls running the tests.
	emake -Onone -j1 HARNESS_JOBS="$(makeopts_jobs)" VFP=1 test
}

multilib_src_install() {
	# Only -j1 is supported for the install targets:
	# https://github.com/openssl/openssl/issues/21999#issuecomment-1771150305
	emake DESTDIR="${D}" -j1 install_sw
	if use fips; then
		emake DESTDIR="${D}" -j1 install_fips
		# Regen this in pkg_preinst, bug 900625
		rm "${ED}${SSL_CNF_DIR}"/fipsmodule.cnf || die
	fi

	if multilib_is_native_abi; then
		emake DESTDIR="${D}" -j1 install_ssldirs
		emake DESTDIR="${D}" DOCDIR='$(INSTALLTOP)'/share/doc/${PF} -j1 install_docs
	fi

	# This is crappy in that the static archives are still built even
	# when USE=static-libs. But this is due to a failing in the openssl
	# build system: the static archives are built as PIC all the time.
	# Only way around this would be to manually configure+compile openssl
	# twice; once with shared lib support enabled and once without.
	if ! use static-libs ; then
		rm "${ED}"/usr/$(get_libdir)/lib{crypto,ssl}.a || die
	fi
}

multilib_src_install_all() {
	# openssl installs perl version of c_rehash by default, but
	# we provide a shell version via app-misc/c_rehash
	rm "${ED}"/usr/bin/c_rehash || die

	dodoc {AUTHORS,CHANGES,NEWS,README,README-PROVIDERS}.md doc/*.txt doc/${PN}-c-indent.el

	# Create the certs directory
	keepdir ${SSL_CNF_DIR}/certs

	# bug #254521
	dodir /etc/sandbox.d
	echo 'SANDBOX_PREDICT="/dev/crypto"' > "${ED}"/etc/sandbox.d/10openssl

	diropts -m0700
	keepdir ${SSL_CNF_DIR}/private
}

pkg_preinst() {
	if use fips; then
		# Regen fipsmodule.cnf, bug 900625
		ebegin "Running openssl fipsinstall"
		"${ED}/usr/bin/openssl" fipsinstall -quiet \
			-out "${ED}${SSL_CNF_DIR}/fipsmodule.cnf" \
			-module "${ED}/usr/$(get_libdir)/ossl-modules/fips.so"
		eend $?
	fi

	preserve_old_lib /usr/$(get_libdir)/lib{crypto,ssl}$(get_libname 1) \
		/usr/$(get_libdir)/lib{crypto,ssl}$(get_libname 1.1)
}

pkg_postinst() {
	ebegin "Running 'openssl rehash ${EROOT}${SSL_CNF_DIR}/certs' to rebuild hashes (bug #333069)"
	openssl rehash "${EROOT}${SSL_CNF_DIR}/certs"
	eend $?

	preserve_old_lib_notify /usr/$(get_libdir)/lib{crypto,ssl}$(get_libname 1) \
		/usr/$(get_libdir)/lib{crypto,ssl}$(get_libname 1.1)
}
