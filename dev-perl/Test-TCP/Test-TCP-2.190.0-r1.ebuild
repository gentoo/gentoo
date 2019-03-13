# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TOKUHIROM
DIST_VERSION=2.19
inherit perl-module

DESCRIPTION="Testing TCP program"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-IO
	virtual/perl-IO-Socket-IP
	>=dev-perl/Test-SharedFork-0.290.0
	virtual/perl-Test-Simple
	>=virtual/perl-IO-1.230.0
	virtual/perl-Time-HiRes
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		>=virtual/perl-Test-Simple-0.980.0
		virtual/perl-File-Temp
		virtual/perl-Socket
	)
"
PATCHES=( "${FILESDIR}/${PN}-2.19-no-dot-inc.patch" )
