# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic toolchain-funcs multilib-minimal

# openssl-1.0.2-patches-1.6 contain additional CVE patches
# which got fixed with this release.
# Please use 1.7 version number when rolling a new tarball!
PATCH_SET="openssl-1.0.2-patches-1.5"

MY_P=${P/_/-}

# This patch set is based on the following files from Fedora 25,
# see https://src.fedoraproject.org/rpms/openssl/blob/25/f/openssl.spec
# for more details:
# - hobble-openssl (SOURCE1)
# - ec_curve.c (SOURCE12) -- MODIFIED
# - ectest.c (SOURCE13)
# - openssl-1.1.1-ec-curves.patch (PATCH37) -- MODIFIED
BINDIST_PATCH_SET="openssl-1.0.2t-bindist-1.0.tar.xz"

DESCRIPTION="full-strength general purpose cryptography library (including SSL and TLS)"
HOMEPAGE="https://www.openssl.org/"
SRC_URI="mirror://openssl/source/${MY_P}.tar.gz
	bindist? (
		mirror://gentoo/${BINDIST_PATCH_SET}
		https://dev.gentoo.org/~whissi/dist/openssl/${BINDIST_PATCH_SET}
	)
	!vanilla? (
		mirror://gentoo/${PATCH_SET}.tar.xz
		https://dev.gentoo.org/~chutzpah/dist/${PN}/${PATCH_SET}.tar.xz
		https://dev.gentoo.org/~whissi/dist/${PN}/${PATCH_SET}.tar.xz
		https://dev.gentoo.org/~polynomial-c/dist/${PATCH_SET}.tar.xz
	)"

LICENSE="openssl"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x86-linux"
IUSE="+asm bindist gmp kerberos rfc3779 sctp cpu_flags_x86_sse2 sslv2 +sslv3 static-libs test tls-compression +tls-heartbeat vanilla"
RESTRICT="!bindist? ( bindist )
	!test? ( test )"

RDEPEND=">=app-misc/c_rehash-1.7-r1
	gmp? ( >=dev-libs/gmp-5.1.3-r1[static-libs(+)?,${MULTILIB_USEDEP}] )
	kerberos? ( >=app-crypt/mit-krb5-1.11.4[${MULTILIB_USEDEP}] )
	tls-compression? ( >=sys-libs/zlib-1.2.8-r1[static-libs(+)?,${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="
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
	if use bindist; then
		mv "${WORKDIR}"/bindist-patches/hobble-openssl "${WORKDIR}" || die
		bash "${WORKDIR}"/hobble-openssl || die

		cp -f "${WORKDIR}"/bindist-patches/ec_curve.c "${S}"/crypto/ec/ || die
		cp -f "${WORKDIR}"/bindist-patches/ectest.c "${S}"/crypto/ec/ || die

		eapply "${WORKDIR}"/bindist-patches/ec-curves.patch

		# Also see the configure parts below:
		# enable-ec \
		# $(use_ssl !bindist ec2m) \
		# $(use_ssl !bindist srp) \
	fi

	# keep this in sync with app-misc/c_rehash
	SSL_CNF_DIR="/etc/ssl"

	# Make sure we only ever touch Makefile.org and avoid patching a file
	# that gets blown away anyways by the Configure script in src_configure
	rm -f Makefile

	if ! use vanilla ; then
		eapply "${WORKDIR}"/patch/*.patch
	fi

	eapply_user

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
	# this breaks build with 1.0.2p, not sure if it is needed anymore
	#sed -i 's/expr.*MAKEDEPEND.*;/true;/' util/domd || die

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
	# Camellia: Royalty Free            https://en.wikipedia.org/wiki/Camellia_(cipher)
	# IDEA:     Expired                 https://en.wikipedia.org/wiki/International_Data_Encryption_Algorithm
	# EC:       ????????? ??/??/2015    https://en.wikipedia.org/wiki/Elliptic_Curve_Cryptography
	# MDC2:     Expired                 https://en.wikipedia.org/wiki/MDC-2
	# RC5:      Expired                 https://en.wikipedia.org/wiki/RC5

	use_ssl() { usex $1 "enable-${2:-$1}" "no-${2:-$1}" " ${*:3}" ; }
	echoit() { echo "$@" ; "$@" ; }

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

	# https://github.com/openssl/openssl/issues/2286
	if use ia64 ; then
		replace-flags -g3 -g2
		replace-flags -ggdb3 -ggdb2
	fi

	local sslout=$(./gentoo.config)
	einfo "Use configuration ${sslout:-(openssl knows best)}"
	local config="Configure"
	[[ -z ${sslout} ]] && config="config"

	# Fedora hobbled-EC needs 'no-ec2m', 'no-srp'
	# Make sure user flags don't get added *yet* to avoid duplicated
	# flags.
	CFLAGS= LDFLAGS= echoit \
	./${config} \
		${sslout} \
		$(use cpu_flags_x86_sse2 || echo "no-sse2") \
		enable-camellia \
		enable-ec \
		$(use_ssl !bindist ec2m) \
		$(use_ssl !bindist srp) \
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
		$(use_ssl sslv2 ssl2) \
		$(use_ssl sslv3 ssl3) \
		$(use_ssl tls-compression zlib) \
		$(use_ssl tls-heartbeat heartbeats) \
		--prefix="${EPREFIX}"/usr \
		--openssldir="${EPREFIX}"${SSL_CNF_DIR} \
		--libdir=$(get_libdir) \
		shared threads \
		|| die

	# Clean out hardcoded flags that openssl uses
	local DEFAULT_CFLAGS=$(grep ^CFLAG= Makefile | LC_ALL=C sed \
		-e 's:^CFLAG=::' \
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
		-e "/^CFLAG/s|=.*|=${DEFAULT_CFLAGS} ${CFLAGS}|" \
		-e "/^LDFLAGS=/s|=[[:space:]]*$|=${LDFLAGS}|" \
		Makefile || die
}

multilib_src_compile() {
	# depend is needed to use $confopts; it also doesn't matter
	# that it's -j1 as the code itself serializes subdirs
	emake -j1 V=1 depend
	emake all
	# rehash is needed to prep the certs/ dir; do this
	# separately to avoid parallel build issues.
	emake rehash
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

	emake INSTALL_PREFIX="${D}" install

	# This is crappy in that the static archives are still built even
	# when USE=static-libs.  But this is due to a failing in the openssl
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

	local -a DOCS=( CHANGES* FAQ NEWS README doc/*.txt doc/c-indentation.el )
	einstalldocs

	use rfc3779 && dodoc engines/ccgost/README.gost

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

pkg_postinst() {
	ebegin "Running 'c_rehash ${EROOT}${SSL_CNF_DIR}/certs/' to rebuild hashes #333069"
	c_rehash "${EROOT}${SSL_CNF_DIR}/certs" >/dev/null
	eend $?
}
