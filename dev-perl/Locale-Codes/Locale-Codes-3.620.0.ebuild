# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SBECK
DIST_VERSION=3.62
inherit perl-module

DESCRIPTION="A distribution of Perl modules to handle locale codes"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND=">=virtual/perl-ExtUtils-MakeMaker-6.300.0"
RDEPEND="virtual/perl-Carp"
DEPEND="
	test? (
		virtual/perl-Test-Simple
		>=dev-perl/Test-Inter-1.90.0
	)
"
