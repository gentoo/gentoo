# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=1.01
DIST_EXAMPLES=( 'examples/*' )
inherit perl-module

DESCRIPTION="Replaces random number generation with non-random number generation"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="minimal"

RDEPEND="
	virtual/perl-Carp
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		!minimal? (
			virtual/perl-CPAN-Meta
			>=virtual/perl-CPAN-Meta-Requirements-2.120.900
		)
		virtual/perl-File-Spec
		virtual/perl-Scalar-List-Utils
		virtual/perl-Test-Simple
		virtual/perl-version
	)
"
