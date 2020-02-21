# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=MONGODB
DIST_VERSION="v${PV}"

inherit perl-module

DESCRIPTION="Official MongoDB Driver for Perl"
SLOT="0"

KEYWORDS="~amd64"

LICENSE="Apache-2.0"
IUSE="test minimal"
RESTRICT="!test? ( test )"

# IO::Socket::SSL was escallated from suggested to recommended
RDEPEND="
	!minimal? (
		>=virtual/perl-IO-Socket-IP-0.250.0
		>=dev-perl/IO-Socket-SSL-1.560.0
		>=dev-perl/Mozilla-CA-20130114
		>=dev-perl/Net-SSLeay-1.490.0
	)
	>=dev-perl/Authen-SCRAM-0.3.0
	dev-perl/BSON
	virtual/perl-Carp
	dev-perl/Class-XSAccessor
	>=dev-perl/DateTime-0.780.0
	virtual/perl-Digest-MD5
	virtual/perl-Encode
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-IO
	virtual/perl-MIME-Base64
	>=dev-perl/Moo-2
	dev-perl/Safe-Isa
	virtual/perl-Scalar-List-Utils
	virtual/perl-Socket
	dev-perl/Tie-IxHash
	virtual/perl-Time-HiRes
	dev-perl/Try-Tiny
	dev-perl/Type-Tiny
	dev-perl/Type-Tiny-XS
	virtual/perl-XSLoader
	>=dev-perl/boolean-0.250.0
	virtual/perl-if
	dev-perl/namespace-clean
	virtual/perl-version
"
DEPEND="${RDEPEND}
	>=dev-perl/Config-AutoConf-0.220.0
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Path-Tiny-0.52.0
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
			>=dev-perl/DateTime-Tiny-1.0.0
			>=virtual/perl-Test-Harness-3.310.0
			>=dev-perl/Time-Moment-0.220.0
		)
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		dev-perl/JSON-MaybeXS
		virtual/perl-Math-BigInt
		>=dev-perl/Path-Tiny-0.54.0
		>=dev-perl/Test-Deep-0.111.0
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
		virtual/perl-bignum
		virtual/perl-threads-shared
	)
"

pkg_setup() {
	# https://jira.mongodb.org/browse/PERL-766
	LDFLAGS="${LDFLAGS} -lpthread"
}
