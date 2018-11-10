# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MATEU
DIST_VERSION=0.29
inherit perl-module

DESCRIPTION="Some Moosish types and a type builder"

SLOT="0"
KEYWORDS="amd64 hppa ppc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/strictures-2
	>=dev-perl/Module-Runtime-0.14.0
	>=dev-perl/Moo-1.4.2
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-Fatal-0.3.0
		>=virtual/perl-Test-Simple-0.960.0
	)
"
