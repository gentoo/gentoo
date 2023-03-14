# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NLNETLABS
DIST_VERSION=1.37
DIST_EXAMPLES=( "contrib" "demo" )
inherit toolchain-funcs perl-module

DESCRIPTION="Perl Interface to the Domain Name System"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="minimal"

PDEPEND="
	!minimal? ( >=dev-perl/Net-DNS-SEC-1.30.0 )
"
RDEPEND="
	>=virtual/perl-Carp-1.100.0
	>=dev-perl/Digest-HMAC-1.30.0
	>=virtual/perl-Digest-MD5-2.130.0
	>=virtual/perl-Digest-SHA-5.230.0
	>=virtual/perl-Encode-2.260.0
	>=virtual/perl-Exporter-5.630.0
	>=virtual/perl-File-Spec-3.290.0
	>=virtual/perl-MIME-Base64-2.130.0
	>=virtual/perl-Scalar-List-Utils-1.190.0
	>=virtual/perl-Time-Local-1.190.0
	>=virtual/perl-IO-Socket-IP-0.380.0
	>=virtual/perl-IO-1.140.0
	!minimal? (
		>=dev-perl/Digest-BubbleBabble-0.20.0
		>=dev-perl/Net-LibIDN2-1.0.0
	)
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.480.0
	>=virtual/perl-Getopt-Long-2.430.0
	test? (
		>=virtual/perl-Test-Simple-0.520.0
	)
"

src_prepare() {
	perl-module_src_prepare
	mydoc="TODO"
	# --IPv6-tests requires that you have external IPv6 connectivity
	# as it connects to 2001:7b8:206:1:0:1234:be21:e31e
	if ! use test || ! has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		myconf="${myconf} --no-online-tests --no-IPv6-tests"
	fi
}

src_compile() {
	emake FULL_AR="$(tc-getAR)" OTHERLDFLAGS="${LDFLAGS}"
}

src_test() {
	perl_rm_files t/00-pod.t
	if ! has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		elog "Network tests disabled without to DIST_TEST_OVERIDE=~network"
	fi
	perl-module_src_test
}
