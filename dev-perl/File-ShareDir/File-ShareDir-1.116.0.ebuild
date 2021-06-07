# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=REHSACK
DIST_VERSION=1.116
inherit perl-module

DESCRIPTION="Locate per-dist and per-module shared files"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
IUSE="minimal test"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? (
		>=dev-perl/List-MoreUtils-0.428.0
		>=dev-perl/Params-Util-1.70.0
	)
	virtual/perl-Carp
	>=dev-perl/Class-Inspector-1.120.0
	>=virtual/perl-File-Spec-0.800.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.130.0
	test? (
		>=virtual/perl-File-Path-2.80.0
		>=virtual/perl-Test-Simple-0.900.0
	)
"
# Parallel testing fails in t/04_fail.t
# and t/06_old.t due to touching the same paths
# Bug: https://bugs.gentoo.org/741038
# Bug: https://rt.cpan.org/Ticket/Display.html?id=133368
DIST_TEST="do"
