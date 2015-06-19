# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-LogFormat-Compiler/Apache-LogFormat-Compiler-0.320.0.ebuild,v 1.2 2015/06/13 19:25:19 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=KAZEBURO
MODULE_VERSION=0.32

inherit perl-module

DESCRIPTION="Compile an Apache log format string to perl-code"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# POSIX -> perl
RDEPEND="
	>=dev-perl/POSIX-strftime-Compiler-0.300.0
	virtual/perl-Time-Local
	>=dev-lang/perl-5.8.4"

# CPAN::Meta::Prereqs -> perl-CPAN-Meta
# HTTP::Request::Common -> HTTP-Message
# Test::More -> perl-Test-Simple
# URI::Escape -> URI
DEPEND="${RDEPEND}
		>=dev-perl/Module-Build-0.380.0
		virtual/perl-CPAN-Meta
		test? (
				dev-perl/HTTP-Message
				dev-perl/Test-MockTime
				>=virtual/perl-Test-Simple-0.980.0
				dev-perl/Test-Requires
				>=dev-perl/Try-Tiny-0.120.0
				>=dev-perl/URI-1.600.0
		)
"
SRC_TEST="do parallel"
