# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOBYINK
DIST_VERSION=2.002001
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="tiny, yet Moo(se)-compatible type constraint"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	!<dev-perl/Kavorka-0.13.0
	!<dev-perl/Types-ReadOnly-0.1.0
	!dev-perl/Type-Tie
	>=dev-perl/Exporter-Tiny-1.4.1
	>=virtual/perl-Test-Simple-1.1.10
	!minimal? (
		>=dev-perl/Class-XSAccessor-1.170.0
		>=dev-perl/Devel-LexAlias-0.50.0
		dev-perl/Devel-StackTrace
		>=dev-perl/Ref-Util-XS-0.100.0
		>=dev-perl/Regexp-Util-0.3.0
		virtual/perl-Scalar-List-Utils
		>=dev-perl/Type-Tiny-XS-0.25.0
	)
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	>=virtual/perl-CPAN-Meta-Requirements-2.0.0
	test? (
		dev-perl/Test-Warnings
	)
"
