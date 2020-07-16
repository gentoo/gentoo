# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=RJBS
DIST_VERSION=0.103013
inherit perl-module

DESCRIPTION="upload things to the CPAN"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
	dev-perl/File-HomeDir
	virtual/perl-File-Spec
	>=dev-perl/Getopt-Long-Descriptive-0.84.0
	dev-perl/HTTP-Message
	>=dev-perl/LWP-Protocol-https-1.0.0
	dev-perl/libwww-perl
	dev-perl/TermReadKey
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		>=virtual/perl-Test-Simple-0.960.0
	)
"
