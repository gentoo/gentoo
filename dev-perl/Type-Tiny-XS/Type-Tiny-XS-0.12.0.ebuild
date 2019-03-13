# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TOBYINK
DIST_VERSION=0.012
inherit perl-module

DESCRIPTION="provides an XS boost for some of Type::Tiny's built-in type constraints"

SLOT="0"
KEYWORDS="amd64 hppa ppc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test minimal"

RDEPEND="
	!minimal? ( dev-perl/Type-Tiny )
"
DEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		>=virtual/perl-Test-Simple-0.920.0
	)
"
