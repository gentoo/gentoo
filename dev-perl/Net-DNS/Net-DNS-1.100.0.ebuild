# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NLNETLABS
DIST_VERSION=1.10
DIST_EXAMPLES=( "contrib" "demo" )
inherit toolchain-funcs perl-module

DESCRIPTION="Perl Net::DNS - Perl DNS Resolver Module"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="+ipv6 test minimal"
RESTRICT="!test? ( test )"

PDEPEND="!minimal? ( >=dev-perl/Net-DNS-SEC-1.10.0 )"
RDEPEND="
	>=dev-perl/Digest-HMAC-1.30.0
	>=virtual/perl-Digest-MD5-2.130.0
	>=virtual/perl-Digest-SHA-5.230.0
	>=virtual/perl-File-Spec-0.860.0
	>=virtual/perl-MIME-Base64-2.110.0
	>=virtual/perl-Time-Local-1.190.0
	ipv6? (
		|| (
			>=virtual/perl-IO-Socket-IP-0.320.0
			>=dev-perl/IO-Socket-INET6-2.510.0
		)
	)
	!minimal? (
		>=dev-perl/Digest-BubbleBabble-0.10.0
		>=dev-perl/Digest-GOST-0.60.0
		>=dev-perl/Net-LibIDN-0.120.0
		>=virtual/perl-Scalar-List-Utils-1.250.0
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.520.0
	)
"

src_prepare() {
	perl-module_src_prepare
	mydoc="TODO"
	# --IPv6-tests requires that you have external IPv6 connectivity
	# as it connects to 2001:7b8:206:1:0:1234:be21:e31e
	myconf="${myconf} --no-online-tests --no-IPv6-tests"
}

src_compile() {
	emake FULL_AR="$(tc-getAR)" OTHERLDFLAGS="${LDFLAGS}"
}
src_test() {
	perl_rm_files t/00-pod.t
	perl-module_src_test
}
