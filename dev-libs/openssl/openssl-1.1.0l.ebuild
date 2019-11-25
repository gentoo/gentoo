# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic toolchain-funcs multilib multilib-minimal

MY_P=${P/_/-}

# This patch set is based on the following files from Fedora 28,
# see https://src.fedoraproject.org/rpms/openssl/blob/f28/f/openssl.spec
# for more details:
# - hobble-openssl (SOURCE1)
# - ec_curve.c (SOURCE12) -- MODIFIED
# - ectest.c (SOURCE13)
# - openssl-1.1.0-ec-curves.patch (PATCH37) -- MODIFIED
BINDIST_PATCH_SET="openssl-1.1.0l-bindist-1.0.tar.xz"

DESCRIPTION="full-strength general purpose cryptography library (including SSL and TLS)"
HOMEPAGE="https://www.openssl.org/"
SRC_URI="mirror://openssl/source/${MY_P}.tar.gz
	bindist? (
		mirror://gentoo/${BINDIST_PATCH_SET}
		https://dev.gentoo.org/~whissi/dist/openssl/${BINDIST_PATCH_SET}
	)"

LICENSE="openssl"
SLOT="0/1.1" # .so version of libssl/libcrypto
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~x86-linux"
IUSE="+asm bindist elibc_musl rfc3779 sctp cpu_flags_x86_sse2 sslv3 static-libs test tls-heartbeat vanilla zlib"
RESTRICT="!bindist? ( bindist )
	!test? ( test )"

RDEPEND=">=app-misc/c_rehash-1.7-r1
	zlib? ( >=sys-libs/zlib-1.2.8-r1[static-libs(+)?,${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-lang/perl-5
	sctp? ( >=net-misc/lksctp-tools-1.0.12 )
	test? (
		sys-apps/diffutils
		sys-devel/bc
	)"
PDEPEND="app-misc/ca-certificates"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.2a-x32-asm.patch #542618
	"${FILESDIR}"/${PN}-1.1.0j-parallel_install_fix.patch #671602
	"${FILESDIR}"/${PN}-1.1.0k-fix-test_fuzz.patch
)

S="${WORKDIR}/${MY_P}"

MULTILIB_WRAPPED_HEADERS=(
	usr/include/openssl/opensslconf.h
)

src_prepare() {
	if use bindist; then
		mv "${WORKDIR}"/bindist-patches/hobble-openssl "${WORKDIR}" || die
		bash "${WORKDIR}"/hobble-openssl || die

		cp -f "${WORKDIR}"/bindist-patches/ec_curve.c "${S}"/crypto/ec/ || die
		cp -f "${WORKDIR}"/bindist-patches/ectest.c "${S}"/test/ || die

		eapply "${WORKDIR}"/bindist-patches/ec-curves.patch

		local known_failing_test
		for known_failing_test in \
			30-test_evp_extra.t \
			80-test_ssl_new.t \
		; do
			ebegin "Disabling test '${known_failing_test}' which is known to fail with USE=bindist"
			rm test/recipes/${known_failing_test} || die
			eend $?
		done

		# Also see the configure parts below:
		# enable-ec \
		# $(use_ssl !bindist ec2m) \
	fi

	# keep this in sync with app-misc/c_rehash
	SSL_CNF_DIR="/etc/ssl"

	# Make sure we only ever touch Makefile.org and avoid patching a file
	# that gets blown away anyways by the Configure script in src_configure
	rm -f Makefile

	if ! use vanilla ; then
		if [[ $(declare -p PATCHES 2>/dev/null) == "declare -a"* ]] ; then
			[[ ${#PATCHES[@]} -gt 0 ]] && eapply "${PATCHES[@]}"
		fi

		use bindist || eapply "${FILESDIR}"/${PN}-1.1.0l-fix-no-ec2m-in-ec_curve.c.patch
	fi

	eapply_user #332661

	# make sure the man pages are suffixed #302165
	# don't bother building man pages if they're disabled
	# Make DOCDIR Gentoo compliant
	sed -i \
		-e '/^MANSUFFIX/s:=.*:=ssl:' \
		-e '/^MAKEDEPPROG/s:=.*:=$(CC):' \
		-e $(has noman FEATURES \
			&& echo '/^install:/s:install_docs::' \
			|| echo '/^MANDIR=/s:=.*:='${EPREFIX}'/usr/share/man:') \
		-e "/^DOCDIR/s@\$(BASENAME)@&-${PVR}@" \
		Configurations/unix-Makefile.tmpl \
		|| die

	# show the actual commands in the log
	sed -i '/^SET_X/s@=.*@=set -x@' Makefile.shared || die

	# quiet out unknown driver argument warnings since openssl
	# doesn't have well-split CFLAGS and we're making it even worse
	# and 'make depend' uses -Werror for added fun (#417795 again)
	[[ ${CC} == *clang* ]] && append-flags -Qunused-arguments

	# allow openssl to be cross-compiled
	cp "${FILESDIR}"/gentoo.config-1.0.2 gentoo.config || die
	chmod a+rx gentoo.config || die

	append-flags -fno-strict-aliasing
	append-flags $(test-flags-CC -Wa,--noexecstack)
	append-cppflags -DOPENSSL_NO_BUF_FREELISTS

	# Prefixify Configure shebang (#141906)
	sed \
		-e "1s,/usr/bin/env,${EPREFIX}&," \
		-i Configure || die
	# Remove test target when FEATURES=test isn't set
	if ! use test ; then
		sed \
			-e '/^$config{dirs}/s@ "test",@@' \
			-i Configure || die
	fi
	# The config script does stupid stuff to prompt the user.  Kill it.
	sed -i '/stty -icanon min 0 time 50; read waste/d' config || die
	./config --test-sanity || die "I AM NOT SANE"

	multilib_copy_sources
}

multilib_src_configure() {
	unset APPS #197996
	unset SCRIPTS #312551
	unset CROSS_COMPILE #311473

	tc-export CC AR RANLIB RC

	# Clean out patent-or-otherwise-encumbered code
	# Camellia: Royalty Free            https://en.wikipedia.org/wiki/Camellia_(cipher)
	# IDEA:     Expired                 https://en.wikipedia.org/wiki/International_Data_Encryption_Algorithm
	# EC:       ????????? ??/??/2015    https://en.wikipedia.org/wiki/Elliptic_Curve_Cryptography
	# MDC2:     Expired                 https://en.wikipedia.org/wiki/MDC-2
	# RC5:      Expired                 https://en.wikipedia.org/wiki/RC5

	use_ssl() { usex $1 "enable-${2:-$1}" "no-${2:-$1}" " ${*:3}" ; }
	echoit() { echo "$@" ; "$@" ; }

	local krb5=$(has_version app-crypt/mit-krb5 && echo "MIT" || echo "Heimdal")

	# See if our toolchain supports __uint128_t.  If so, it's 64bit
	# friendly and can use the nicely optimized code paths. #460790
	local ec_nistp_64_gcc_128
	# Disable it for now though #469976
	#if ! use bindist ; then
	#	echo "__uint128_t i;" > "${T}"/128.c
	#	if ${CC} ${CFLAGS} -c "${T}"/128.c -o /dev/null >&/dev/null ; then
	#		ec_nistp_64_gcc_128="enable-ec_nistp_64_gcc_128"
	#	fi
	#fi

	local sslout=$(./gentoo.config)
	einfo "Use configuration ${sslout:-(openssl knows best)}"
	local config="Configure"
	[[ -z ${sslout} ]] && config="config"

	# Fedora hobbled-EC needs 'no-ec2m'
	# 'srp' was restricted until early 2017 as well.
	# "disable-deprecated" option breaks too many consumers.
	# Don't set it without thorough revdeps testing.
	# Make sure user flags don't get added *yet* to avoid duplicated
	# flags.
	CFLAGS= LDFLAGS= echoit \
	./${config} \
		${sslout} \
		$(use cpu_flags_x86_sse2 || echo "no-sse2") \
		enable-camellia \
		enable-ec \
		$(use_ssl !bindist ec2m) \
		enable-srp \
		$(use elibc_musl && echo "no-async") \
		${ec_nistp_64_gcc_128} \
		enable-idea \
		enable-mdc2 \
		enable-rc5 \
		$(use_ssl sslv3 ssl3) \
		$(use_ssl sslv3 ssl3-method) \
		$(use_ssl asm) \
		$(use_ssl rfc3779) \
		$(use_ssl sctp) \
		$(use_ssl tls-heartbeat heartbeats) \
		$(use_ssl zlib) \
		--prefix="${EPREFIX}"/usr \
		--openssldir="${EPREFIX}"${SSL_CNF_DIR} \
		--libdir=$(get_libdir) \
		shared threads \
		|| die

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
		Makefile || die
}

multilib_src_compile() {
	# depend is needed to use $confopts; it also doesn't matter
	# that it's -j1 as the code itself serializes subdirs
	emake -j1 depend
	emake all
}

multilib_src_test() {
	emake -j1 test
}

multilib_src_install() {
	# We need to create $ED/usr on our own to avoid a race condition #665130
	if [[ ! -d "${ED}/usr" ]]; then
		# We can only create this directory once
		mkdir "${ED}"/usr || die
	fi

	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	# openssl installs perl version of c_rehash by default, but
	# we provide a shell version via app-misc/c_rehash
	rm "${ED}"/usr/bin/c_rehash || die

	dodoc CHANGES* FAQ NEWS README doc/*.txt doc/${PN}-c-indent.el

	# This is crappy in that the static archives are still built even
	# when USE=static-libs.  But this is due to a failing in the openssl
	# build system: the static archives are built as PIC all the time.
	# Only way around this would be to manually configure+compile openssl
	# twice; once with shared lib support enabled and once without.
	use static-libs || rm -f "${ED}"/usr/lib*/lib*.a

	# create the certs directory
	keepdir ${SSL_CNF_DIR}/certs

	# Namespace openssl programs to prevent conflicts with other man pages
	cd "${ED}"/usr/share/man || die
	local m d s
	for m in $(find . -type f | xargs grep -L '#include') ; do
		d=${m%/*} ; d=${d#./} ; m=${m##*/}
		[[ ${m} == openssl.1* ]] && continue
		[[ -n $(find -L ${d} -type l) ]] && die "erp, broken links already!"
		mv ${d}/{,ssl-}${m}
		# fix up references to renamed man pages
		sed -i '/^[.]SH "SEE ALSO"/,/^[.]/s:\([^(, ]*(1)\):ssl-\1:g' ${d}/ssl-${m}
		ln -s ssl-${m} ${d}/openssl-${m}
		# locate any symlinks that point to this man page ... we assume
		# that any broken links are due to the above renaming
		for s in $(find -L ${d} -type l) ; do
			s=${s##*/}
			rm -f ${d}/${s}
			# We don't want to "|| die" here
			ln -s ssl-${m} ${d}/ssl-${s}
			ln -s ssl-${s} ${d}/openssl-${s}
		done
	done
	[[ -n $(find -L ${d} -type l) ]] && die "broken manpage links found :("

	dodir /etc/sandbox.d #254521
	echo 'SANDBOX_PREDICT="/dev/crypto"' > "${ED}"/etc/sandbox.d/10openssl

	diropts -m0700
	keepdir ${SSL_CNF_DIR}/private
}

pkg_postinst() {
	ebegin "Running 'c_rehash ${EROOT}${SSL_CNF_DIR}/certs/' to rebuild hashes #333069"
	c_rehash "${EROOT}${SSL_CNF_DIR}/certs" >/dev/null
	eend $?
}
