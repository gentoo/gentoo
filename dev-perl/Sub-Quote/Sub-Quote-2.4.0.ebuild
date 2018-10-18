# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=HAARG
DIST_VERSION=2.004000
inherit perl-module

DESCRIPTION="Efficient generation of subroutines via string eval"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test minimal"

RDEPEND="
	!<dev-perl/Moo-2.3.0
	!minimal? (
		>=dev-perl/Sub-Name-0.80.0
	)
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-Fatal-0.3.0
		>=virtual/perl-Test-Simple-0.940.0
	)
"
