# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils flag-o-matic toolchain-funcs multilib multilib-minimal

MY_P=${P/_/-}
DESCRIPTION="full-strength general purpose cryptography library (including SSL and TLS)"
HOMEPAGE="http://www.openssl.org/"
SRC_URI="mirror://openssl/source/${MY_P}.tar.gz"

LICENSE="openssl"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="+asm bindist gmp kerberos rfc3779 sctp cpu_flags_x86_sse2 static-libs test +tls-heartbeat vanilla zlib"
RESTRICT="!bindist? ( bindist )"

# The blocks are temporary just to make sure people upgrade to a
# version that lack runtime version checking.  We'll drop them in
# the future.
RDEPEND=">=app-misc/c_rehash-1.7-r1
	gmp? ( >=dev-libs/gmp-5.1.3-r1[static-libs(+)?,${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[static-libs(+)?,${MULTILIB_USEDEP}] )
	kerberos? ( >=app-crypt/mit-krb5-1.11.4[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)
	!<net-misc/openssh-5.9_p1-r4
	!<net-libs/neon-0.29.6-r1"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	sctp? ( >=net-misc/lksctp-tools-1.0.12 )
	test? (
		sys-apps/diffutils
		sys-devel/bc
	)"
PDEPEND="app-misc/ca-certificates"

S="${WORKDIR}/${MY_P}"

MULTILIB_WRAPPED_HEADERS=(
	usr/include/openssl/opensslconf.h
)

src_prepare() {
	# keep this in sync with app-misc/c_rehash
	SSL_CNF_DIR="/etc/ssl"

	# Make sure we only ever touch Makefile.org and avoid patching a file
	# that gets blown away anyways by the Configure script in src_configure
	rm -f Makefile

	if ! use vanilla ; then
		epatch "${FILESDIR}"/${PN}-1.0.0a-ldflags.patch #327421
		epatch "${FILESDIR}"/${PN}-1.0.0d-windres.patch #373743
		epatch "${FILESDIR}"/${PN}-1.0.2e-parallel-build.patch
		epatch "${FILESDIR}"/${PN}-1.0.2a-parallel-obj-headers.patch
		epatch "${FILESDIR}"/${PN}-1.0.2a-parallel-install-dirs.patch
		epatch "${FILESDIR}"/${PN}-1.0.2a-parallel-symlinking.patch #545028
		epatch "${FILESDIR}"/${PN}-1.0.2-ipv6.patch
		epatch "${FILESDIR}"/${PN}-1.0.2a-x32-asm.patch #542618
		epatch "${FILESDIR}"/${PN}-1.0.1p-default-source.patch #554338

		epatch_user #332661
	fi

	# disable fips in the build
	# make sure the man pages are suffixed #302165
	# don't bother building man pages if they're disabled
	sed -i \
		-e '/DIRS/s: fips : :g' \
		-e '/^MANSUFFIX/s:=.*:=ssl:' \
		-e '/^MAKEDEPPROG/s:=.*:=$(CC):' \
		-e $(has noman FEATURES \
			&& echo '/^install:/s:install_docs::' \
			|| echo '/^MANDIR=/s:=.*:='${EPREFIX}'/usr/share/man:') \
		Makefile.org \
		|| die
	# show the actual commands in the log
	sed -i '/^SET_X/s:=.*:=set -x:' Makefile.shared

	# since we're forcing $(CC) as makedep anyway, just fix
	# the conditional as always-on
	# helps clang (#417795), and versioned gcc (#499818)
	sed -i 's/expr.*MAKEDEPEND.*;/true;/' util/domd || die

	# quiet out unknown driver argument warnings since openssl
	# doesn't have well-split CFLAGS and we're making it even worse
	# and 'make depend' uses -Werror for added fun (#417795 again)
	[[ ${CC} == *clang* ]] && append-flags -Qunused-arguments

	# allow openssl to be cross-compiled
	cp "${FILESDIR}"/gentoo.config-1.0.2 gentoo.config || die
	chmod a+rx gentoo.config

	append-flags -fno-strict-aliasing
	append-flags $(test-flags-CC -Wa,--noexecstack)
	append-cppflags -DOPENSSL_NO_BUF_FREELISTS

	sed -i '1s,^:$,#!'${EPREFIX}'/usr/bin/perl,' Configure #141906
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
	# Camellia: Royalty Free            http://en.wikipedia.org/wiki/Camellia_(cipher)
	# IDEA:     Expired                 http://en.wikipedia.org/wiki/International_Data_Encryption_Algorithm
	# EC:       ????????? ??/??/2015    http://en.wikipedia.org/wiki/Elliptic_Curve_Cryptography
	# MDC2:     Expired                 http://en.wikipedia.org/wiki/MDC-2
	# RC5:      Expired                 http://en.wikipedia.org/wiki/RC5

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

	echoit \
	./${config} \
		${sslout} \
		$(use cpu_flags_x86_sse2 || echo "no-sse2") \
		enable-camellia \
		$(use_ssl !bindist ec) \
		${ec_nistp_64_gcc_128} \
		enable-idea \
		enable-mdc2 \
		enable-rc5 \
		enable-tlsext \
		$(use_ssl asm) \
		$(use_ssl gmp gmp -lgmp) \
		$(use_ssl kerberos krb5 --with-krb5-flavor=${krb5}) \
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
	local CFLAG=$(grep ^CFLAG= Makefile | LC_ALL=C sed \
		-e 's:^CFLAG=::' \
		-e 's:-fomit-frame-pointer ::g' \
		-e 's:-O[0-9] ::g' \
		-e 's:-march=[-a-z0-9]* ::g' \
		-e 's:-mcpu=[-a-z0-9]* ::g' \
		-e 's:-m[a-z0-9]* ::g' \
	)
	sed -i \
		-e "/^CFLAG/s|=.*|=${CFLAG} ${CFLAGS}|" \
		-e "/^SHARED_LDFLAGS=/s|$| ${LDFLAGS}|" \
		Makefile || die
}

multilib_src_compile() {
	# depend is needed to use $confopts; it also doesn't matter
	# that it's -j1 as the code itself serializes subdirs
	emake -j1 depend
	emake all
	# rehash is needed to prep the certs/ dir; do this
	# separately to avoid parallel build issues.
	emake rehash
}

multilib_src_test() {
	emake -j1 test
}

multilib_src_install() {
	emake INSTALL_PREFIX="${D}" install
}

multilib_src_install_all() {
	# openssl installs perl version of c_rehash by default, but
	# we provide a shell version via app-misc/c_rehash
	rm "${ED}"/usr/bin/c_rehash || die

	dodoc CHANGES* FAQ NEWS README doc/*.txt doc/c-indentation.el
	dohtml -r doc/*
	use rfc3779 && dodoc engines/ccgost/README.gost

	# This is crappy in that the static archives are still built even
	# when USE=static-libs.  But this is due to a failing in the openssl
	# build system: the static archives are built as PIC all the time.
	# Only way around this would be to manually configure+compile openssl
	# twice; once with shared lib support enabled and once without.
	use static-libs || rm -f "${ED}"/usr/lib*/lib*.a

	# create the certs directory
	dodir ${SSL_CNF_DIR}/certs
	cp -RP certs/* "${ED}"${SSL_CNF_DIR}/certs/ || die
	rm -r "${ED}"${SSL_CNF_DIR}/certs/{demo,expired}

	# Namespace openssl programs to prevent conflicts with other man pages
	cd "${ED}"/usr/share/man
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

pkg_preinst() {
	has_version ${CATEGORY}/${PN}:0.9.8 && return 0
	preserve_old_lib /usr/$(get_libdir)/lib{crypto,ssl}.so.0.9.8
}

pkg_postinst() {
	ebegin "Running 'c_rehash ${EROOT%/}${SSL_CNF_DIR}/certs/' to rebuild hashes #333069"
	c_rehash "${EROOT%/}${SSL_CNF_DIR}/certs" >/dev/null
	eend $?

	has_version ${CATEGORY}/${PN}:0.9.8 && return 0
	preserve_old_lib_notify /usr/$(get_libdir)/lib{crypto,ssl}.so.0.9.8
}
