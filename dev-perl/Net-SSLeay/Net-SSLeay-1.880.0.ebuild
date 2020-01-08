# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHRISN
DIST_VERSION=1.88
DIST_EXAMPLES=("examples/*")
inherit multilib perl-module

DESCRIPTION="Perl extension for using OpenSSL"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="libressl test minimal examples"
RESTRICT="!test? ( test )"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	virtual/perl-MIME-Base64
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			dev-perl/Test-Exception
			dev-perl/Test-Warn
			dev-perl/Test-NoWarnings
		)
		virtual/perl-Test-Simple
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.88-fix-network-tests.patch"
	"${FILESDIR}/${PN}-1.88-fix-libdir.patch"
)
PERL_RM_FILES=(
	# Hateful author tests
	't/local/01_pod.t'
	't/local/02_pod_coverage.t'
	't/local/kwalitee.t'
)

src_configure() {
	if use test && has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		export NETWORK_TESTS=yes
	else
		use test && einfo "Network tests will be skipped without DIST_TEST_OVERRIDE=~network"
		export NETWORK_TESTS=no
	fi
	export LIBDIR=$(get_libdir)
	perl-module_src_configure
}

src_compile() {
	mymake=(
		OPTIMIZE="${CFLAGS}"
		OPENSSL_PREFIX="${EPREFIX}"/usr
	)
	perl-module_src_compile
}
