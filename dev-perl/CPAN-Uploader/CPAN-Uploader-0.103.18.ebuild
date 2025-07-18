# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=0.103018
inherit perl-module

DESCRIPTION="Upload things to the CPAN"

SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test minimal"
RESTRICT="!test? ( test )"

# r: File::Basename -> perl
# r: HTTP::Request::Common -> HTTP-Message
# r: HTTP::Status -> HTTP-Message
# r: LWP::UserAgent -> libwww-perl
# r: strict, warnings -> perl
RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Digest-MD5
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	>=dev-perl/Getopt-Long-Descriptive-0.84.0
	dev-perl/HTTP-Message
	>=dev-perl/LWP-Protocol-https-1.0.0
	dev-perl/libwww-perl
	dev-perl/TermReadKey
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		>=virtual/perl-Test-Simple-0.960.0
	)
"
