# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TOBYINK
DIST_VERSION=1.002000
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="tiny, yet Moo(se)-compatible type constraint"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test minimal"

# Test rdep for Test::TypeTiny
RDEPEND="
	!<dev-perl/Kavorka-0.13.0
	!<dev-perl/Types-ReadOnly-0.1.0
	>=dev-perl/Exporter-Tiny-0.26.0
	>=virtual/perl-Test-Simple-1.1.10
	!minimal? (
		>=dev-perl/Devel-LexAlias-0.50.0
		dev-perl/Devel-StackTrace
		>=dev-perl/Ref-Util-XS-0.116.0
		>=dev-perl/Regexp-Util-0.3.0
		virtual/perl-Scalar-List-Utils
		dev-perl/Type-Tie
		>=dev-perl/Type-Tiny-XS-0.11.0
	)
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	>=virtual/perl-CPAN-Meta-Requirements-2.0.0
	test? (
		dev-perl/Test-Warnings
	)
"
