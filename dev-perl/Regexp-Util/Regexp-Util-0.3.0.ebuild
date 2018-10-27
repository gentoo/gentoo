# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TOBYINK
DIST_VERSION=0.003
inherit perl-module

DESCRIPTION="General purpose utilities for working with Regular Expressions"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	virtual/perl-ExtUtils-Constant
	test? (
		>=virtual/perl-Test-Simple-0.920.0
	)
"
