# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# this ebuild is only for the libcrypto.so.0.9.8 and libssl.so.0.9.8 SONAME for ABI compat

EAPI="6"

inherit eutils flag-o-matic toolchain-funcs multilib multilib-minimal

#PLEVEL=$(printf "\\$(printf '%03o' $((${PV##*_p} + 96)))")
PLEVEL='h' # _p8 -> tr '[1-9]' '[a-i]' -> 'h'
MY_PV=${PV/_p*/${PLEVEL}}
MY_P=openssl-${MY_PV}
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Toolkit for SSL v2/v3 and TLS v1"
HOMEPAGE="https://www.openssl.org/"
SRC_URI="mirror://openssl/source/${MY_P}.tar.gz"

LICENSE="openssl"
SLOT="0.9.8"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc x86"
IUSE="bindist gmp kerberos cpu_flags_x86_sse2 test zlib"
RESTRICT="!bindist? ( bindist )
	test"

RDEPEND="gmp? ( >=dev-libs/gmp-5.1.3-r1[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	kerberos? ( >=app-crypt/mit-krb5-1.11.4[${MULTILIB_USEDEP}] )
	!=dev-libs/openssl-0.9.8*:0
	!dev-libs/openssl:0.9.8"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	test? (
		sys-apps/diffutils
		sys-devel/bc
	)"

# Do not install any docs
DOCS=()

PATCHES=(
	"${FILESDIR}"/openssl-0.9.8e-bsd-sparc64.patch
	"${FILESDIR}"/openssl-0.9.8h-ldflags.patch #181438
	"${FILESDIR}"/openssl-0.9.8m-binutils.patch #289130
	"${FILESDIR}"/openssl-0.9.8z_p8-perl-5.26.patch
)

src_prepare() {
	default

	# disable fips in the build
	# make sure the man pages are suffixed #302165
	# don't bother building man pages if they're disabled
	sed -i \
		-e '/DIRS/s: fips : :g' \
		-e '/^MANSUFFIX/s:=.*:=ssl:' \
		-e '/^MAKEDEPPROG/s:=.*:=$(CC):' \
		-e $(has noman FEATURES \
			&& echo '/^install:/s:install_docs::' \
			|| echo '/^MANDIR=/s:=.*:=/usr/share/man:') \
		Makefile{,.org} \
		|| die
	# show the actual commands in the log
	sed -i '/^SET_X/s:=.*:=set -x:' Makefile.shared || die
	# update the enginedir path.
	# punt broken config we don't care about as it fails sanity check.
	sed -i \
		-e '/^"debug-ben-debug-64"/d' \
		-e "/foo.*engines/s|/lib/engines|/$(get_libdir)/engines|" \
		Configure || die

	# since we're forcing $(CC) as makedep anyway, just fix
	# the conditional as always-on
	# helps clang (#417795), and versioned gcc (#499818)
	sed -i 's/expr.*MAKEDEPEND.*;/true;/' util/domd || die

	# quiet out unknown driver argument warnings since openssl
	# doesn't have well-split CFLAGS and we're making it even worse
	# and 'make depend' uses -Werror for added fun (#417795 again)
	[[ ${CC} == *clang* ]] && append-flags -Qunused-arguments

	# allow openssl to be cross-compiled
	cp "${FILESDIR}"/gentoo.config-0.9.8 gentoo.config || die "cp cross-compile failed"
	chmod a+rx gentoo.config || die

	append-flags -fno-strict-aliasing
	append-flags -Wa,--noexecstack

	sed -i '1s,^:$,#!/usr/bin/perl,' Configure || die #141906
	sed -i '/^"debug-bodo/d' Configure || die # 0.9.8za shipped broken
	./config --test-sanity || die "I AM NOT SANE"

	multilib_copy_sources
}

multilib_src_configure() {
	unset APPS #197996
	unset SCRIPTS #312551

	tc-export CC AR RANLIB

	# Clean out patent-or-otherwise-encumbered code
	# Camellia: Royalty Free            https://en.wikipedia.org/wiki/Camellia_(cipher)
	# IDEA:     Expired                 https://en.wikipedia.org/wiki/International_Data_Encryption_Algorithm
	# EC:       ????????? ??/??/2015    https://en.wikipedia.org/wiki/Elliptic_Curve_Cryptography
	# MDC2:     Expired                 https://en.wikipedia.org/wiki/MDC-2
	# RC5:      5,724,428 03/03/2015    https://en.wikipedia.org/wiki/RC5

	use_ssl() { use $1 && echo "enable-${2:-$1} ${*:3}" || echo "no-${2:-$1}" ; }
	echoit() { echo "$@" ; "$@" ; }

	local krb5=$(has_version app-crypt/mit-krb5 && echo "MIT" || echo "Heimdal")

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
		enable-idea \
		enable-mdc2 \
		$(use_ssl !bindist rc5) \
		enable-tlsext \
		$(use_ssl gmp gmp -lgmp) \
		$(use_ssl kerberos krb5 --with-krb5-flavor=${krb5}) \
		$(use_ssl zlib) \
		--prefix=/usr \
		--openssldir=/etc/ssl \
		shared threads \
		|| die "Configure failed"

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
		-e "/^LIBDIR=/s|=.*|=$(get_libdir)|" \
		-e "/^CFLAG/s|=.*|=${CFLAG} ${CFLAGS}|" \
		-e "/^SHARED_LDFLAGS=/s|$| ${LDFLAGS}|" \
		Makefile || die
}

multilib_src_compile() {
	# depend is needed to use $confopts
	emake -j1 depend
	emake -j1 build_libs
}

multilib_src_test() {
	emake -j1 test
}

multilib_src_install() {
	dolib.so lib{crypto,ssl}.so.0.9.8
}
