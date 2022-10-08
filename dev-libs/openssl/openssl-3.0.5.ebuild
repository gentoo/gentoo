# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/openssl.org.asc
inherit edo flag-o-matic linux-info toolchain-funcs multilib-minimal multiprocessing verify-sig

DESCRIPTION="Robust, full-featured Open Source Toolkit for the Transport Layer Security (TLS)"
HOMEPAGE="https://www.openssl.org/"

MY_P=${P/_/-}

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/openssl/openssl.git"

	inherit git-r3
else
	SRC_URI="mirror://openssl/source/${MY_P}.tar.gz
		verify-sig? ( mirror://openssl/source/${MY_P}.tar.gz.asc )"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x86-linux"
fi

S="${WORKDIR}"/${MY_P}

LICENSE="Apache-2.0"
SLOT="0/3" # .so version of libssl/libcrypto
IUSE="+asm cpu_flags_x86_sse2 fips ktls rfc3779 sctp static-libs test tls-compression vanilla verify-sig weak-ssl-ciphers"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=app-misc/c_rehash-1.7-r1
	tls-compression? ( >=sys-libs/zlib-1.2.8-r1[static-libs(+)?,${MULTILIB_USEDEP}] )
"
BDEPEND="
	>=dev-lang/perl-5
	sctp? ( >=net-misc/lksctp-tools-1.0.12 )
	test? (
		sys-apps/diffutils
		sys-devel/bc
		sys-process/procps
	)
	verify-sig? ( sec-keys/openpgp-keys-openssl )"

DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
PDEPEND="app-misc/ca-certificates"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/openssl/configuration.h
)

PATCHES=(
	"${FILESDIR}"/${P}-test-memcmp.patch
)

pkg_setup() {
	if use ktls ; then
		if kernel_is -lt 4 18 ; then
			ewarn "Kernel implementation of TLS (USE=ktls) requires kernel >=4.18!"
		else
			CONFIG_CHECK="~TLS ~TLS_DEVICE"
			ERROR_TLS="You will be unable to offload TLS to kernel because CONFIG_TLS is not set!"
			ERROR_TLS_DEVICE="You will be unable to offload TLS to kernel because CONFIG_TLS_DEVICE is not set!"

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
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.gz{,.asc}
	fi

	default
}

src_prepare() {
	# Allow openssl to be cross-compiled
	cp "${FILESDIR}"/gentoo.config-1.0.2 gentoo.config || die
	chmod a+rx gentoo.config || die

	# Keep this in sync with app-misc/c_rehash
	SSL_CNF_DIR="/etc/ssl"

	# Make sure we only ever touch Makefile.org and avoid patching a file
	# that gets blown away anyways by the Configure script in src_configure
	rm -f Makefile

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

	# - Make sure the man pages are suffixed (bug #302165)
	# - Don't bother building man pages if they're disabled
	# - Make DOCDIR Gentoo compliant
	sed -i \
		-e '/^MANSUFFIX/s:=.*:=ssl:' \
		-e '/^MAKEDEPPROG/s:=.*:=$(CC):' \
		-e $(has noman FEATURES \
			&& echo '/^install:/s:install_docs::' \
			|| echo '/^MANDIR=/s:=.*:='${EPREFIX}'/usr/share/man:') \
		-e "/^DOCDIR/s@\$(BASENAME)@&-${PVR}@" \
		Configurations/unix-Makefile.tmpl \
		|| die

	# Quiet out unknown driver argument warnings since openssl
	# doesn't have well-split CFLAGS and we're making it even worse
	# and 'make depend' uses -Werror for added fun (bug #417795 again)
	tc-is-clang && append-flags -Qunused-arguments

	# We really, really need to build OpenSSL w/ strict aliasing disabled.
	# It's filled with violations and it *will* result in miscompiled
	# code. This has been in the ebuild for > 10 years but even in 2022,
	# it's still relevant:
	# - https://github.com/llvm/llvm-project/issues/55255
	# - https://github.com/openssl/openssl/issues/18225
	# - https://github.com/openssl/openssl/issues/18663#issuecomment-1181478057
	# Don't remove the no strict aliasing bits below!
	filter-flags -fstrict-aliasing
	append-flags -fno-strict-aliasing

	append-flags $(test-flags-CC -Wa,--noexecstack)

	# Prefixify Configure shebang (bug #141906)
	sed \
		-e "1s,/usr/bin/env,${BROOT}&," \
		-i Configure || die

	# Remove test target when FEATURES=test isn't set
	if ! use test ; then
		sed \
			-e '/^$config{dirs}/s@ "test",@@' \
			-i Configure || die
	fi

	# The config script does stupid stuff to prompt the user. Kill it.
	sed -i '/stty -icanon min 0 time 50; read waste/d' config || die
	./config --test-sanity || die "I AM NOT SANE"

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

	local krb5=$(has_version app-crypt/mit-krb5 && echo "MIT" || echo "Heimdal")

	local sslout=$(./gentoo.config)
	einfo "Using configuration: ${sslout:-(openssl knows best)}"
	local config="Configure"
	[[ -z ${sslout} ]] && config="config"

	# https://github.com/openssl/openssl/blob/master/INSTALL.md#enable-and-disable-features
	local myeconfargs=(
		${sslout}

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

	CFLAGS= LDFLAGS= edo ./${config} "${myeconfargs[@]}"

	# Clean out hardcoded flags that openssl uses
	local DEFAULT_CFLAGS=$(grep ^CFLAGS= Makefile | LC_ALL=C sed \
		-e 's:^CFLAGS=::' \
		-e 's:\(^\| \)-fomit-frame-pointer::g' \
		-e 's:\(^\| \)-O[^ ]*::g' \
		-e 's:\(^\| \)-march=[^ ]*::g' \
		-e 's:\(^\| \)-mcpu=[^ ]*::g' \
		-e 's:\(^\| \)-m[^ ]*::g' \
		-e 's:^ *::' \
		-e 's: *$::' \
		-e 's: \+: :g' \
		-e 's:\\:\\\\:g'
	)

	# Now insert clean default flags with user flags
	sed -i \
		-e "/^CFLAGS=/s|=.*|=${DEFAULT_CFLAGS} ${CFLAGS}|" \
		-e "/^LDFLAGS=/s|=[[:space:]]*$|=${LDFLAGS}|" \
		Makefile \
		|| die
}

multilib_src_compile() {
	# depend is needed to use $confopts; it also doesn't matter
	# that it's -j1 as the code itself serializes subdirs
	emake -j1 depend

	emake all
}

multilib_src_test() {
	# VFP = show subtests verbosely and show failed tests verbosely
	# Normal V=1 would show everything verbosely but this slows things down.
	emake HARNESS_JOBS="$(makeopts_jobs)" VFP=1 test
}

multilib_src_install() {
	# We need to create ${ED}/usr on our own to avoid a race condition (bug #665130)
	dodir /usr

	emake DESTDIR="${D}" install

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

	# Namespace openssl programs to prevent conflicts with other man pages
	cd "${ED}"/usr/share/man || die
	local m d s
	for m in $(find . -type f | xargs grep -L '#include') ; do
		d=${m%/*}
		d=${d#./}
		m=${m##*/}

		[[ ${m} == openssl.1* ]] && continue

		[[ -n $(find -L ${d} -type l) ]] && die "erp, broken links already!"

		mv ${d}/{,ssl-}${m} || die

		# Fix up references to renamed man pages
		sed -i '/^[.]SH "SEE ALSO"/,/^[.]/s:\([^(, ]*(1)\):ssl-\1:g' ${d}/ssl-${m} || die
		ln -s ssl-${m} ${d}/openssl-${m} || die

		# Locate any symlinks that point to this man page
		# We assume that any broken links are due to the above renaming
		for s in $(find -L ${d} -type l) ; do
			s=${s##*/}

			rm -f ${d}/${s}

			# We don't want to "|| die" here
			ln -s ssl-${m} ${d}/ssl-${s}
			ln -s ssl-${s} ${d}/openssl-${s}
		done
	done
	[[ -n $(find -L ${d} -type l) ]] && die "broken manpage links found :("

	# bug #254521
	dodir /etc/sandbox.d
	echo 'SANDBOX_PREDICT="/dev/crypto"' > "${ED}"/etc/sandbox.d/10openssl

	diropts -m0700
	keepdir ${SSL_CNF_DIR}/private
}

pkg_postinst() {
	ebegin "Running 'c_rehash ${EROOT}${SSL_CNF_DIR}/certs/' to rebuild hashes (bug #333069)"
	c_rehash "${EROOT}${SSL_CNF_DIR}/certs" >/dev/null
	eend $?
}
