# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KAZEBURO
DIST_VERSION=0.35
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Compile an Apache log format string to perl-code"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

# POSIX -> perl
RDEPEND="
	>=dev-perl/POSIX-strftime-Compiler-0.300.0
	virtual/perl-Time-Local
	>=dev-lang/perl-5.8.4"

# HTTP::Request::Common -> HTTP-Message
# Test::More -> perl-Test-Simple
# URI::Escape -> URI
DEPEND="${RDEPEND}
		>=dev-perl/Module-Build-Tiny-0.35.0
		test? (
				dev-perl/HTTP-Message
				dev-perl/Test-MockTime
				>=virtual/perl-Test-Simple-0.980.0
				dev-perl/Test-Requires
				>=dev-perl/Try-Tiny-0.120.0
				>=dev-perl/URI-1.600.0
		)
"
