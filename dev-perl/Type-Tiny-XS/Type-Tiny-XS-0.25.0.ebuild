# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOBYINK
DIST_VERSION=0.025
inherit perl-module

DESCRIPTION="provides an XS boost for some of Type::Tiny's built-in type constraints"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? ( dev-perl/Type-Tiny )
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.580.0
	>=virtual/perl-ExtUtils-ParseXS-3.160.0
	test? (
		>=virtual/perl-Test-Simple-0.920.0
	)
"
