# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CJM
DIST_VERSION=1.05
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Word wrap text by breaking long lines"

SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="virtual/perl-Carp"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		!minimal? (
			dev-perl/Test-Differences
		)
		virtual/perl-Test-Simple
	)
"
