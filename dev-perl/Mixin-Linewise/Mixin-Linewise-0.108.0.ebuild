# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=RJBS
DIST_VERSION=0.108
inherit perl-module

DESCRIPTION="write your linewise code for handles; this does the rest"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"
RESTRICT="!test? ( test )"
# r: IO::File -> IO
# r: strict, warnings -> perl
# t: lib, utf8 -> perl
RDEPEND="
	virtual/perl-Carp
	virtual/perl-IO
	dev-perl/PerlIO-utf8_strict
	dev-perl/Sub-Exporter
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		virtual/perl-Encode
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
