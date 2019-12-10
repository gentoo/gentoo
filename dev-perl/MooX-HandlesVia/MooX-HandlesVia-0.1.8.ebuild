# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MATTP
DIST_VERSION=0.001008
inherit perl-module

DESCRIPTION="NativeTrait-like behavior for Moo"

SLOT="0"
KEYWORDS="amd64 hppa ppc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Class-Method-Modifiers
	>=dev-perl/Data-Perl-0.2.6
	dev-perl/Module-Runtime
	>=dev-perl/Moo-1.3.0
	dev-perl/Role-Tiny
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/MooX-Types-MooseLike-0.230.0
		dev-perl/Test-Exception
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
	)
"
