# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CHRISN
DIST_VERSION=1.94
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Perl extension for using OpenSSL"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="minimal examples"

RDEPEND="
	dev-libs/openssl:=
	virtual/perl-MIME-Base64
"
DEPEND="${RDEPEND}"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Spec
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
	"${FILESDIR}/${PN}-1.940.0-avoid-runtime-check.patch"
)

PERL_RM_FILES=(
	# Author tests
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
	export OPENSSL_PREFIX="${ESYSROOT}/usr"
	perl-module_src_configure
}

src_compile() {
	mymake=(
		OPTIMIZE="${CFLAGS}"
		OPENSSL_PREFIX="${ESYSROOT}"/usr
	)
	perl-module_src_compile
}
