# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=CJM
DIST_VERSION=1.05
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Word wrap text by breaking long lines"

SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="test minimal"

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
