# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=KAZEBURO
DIST_VERSION=0.36
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Compile an Apache log format string to perl-code"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

# POSIX -> perl
RDEPEND="
	>=dev-perl/POSIX-strftime-Compiler-0.300.0
	virtual/perl-Time-Local
	>=dev-lang/perl-5.8.4
"
DEPEND="
	dev-perl/Module-Build-Tiny
"
# HTTP::Request::Common -> HTTP-Message
# Test::More -> perl-Test-Simple
# URI::Escape -> URI
BDEPEND="${RDEPEND}
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
