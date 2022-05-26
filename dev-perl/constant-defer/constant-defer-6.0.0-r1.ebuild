# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=KRYDE
DIST_VERSION="6"
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="constant subs with deferred value calculation"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="test examples"
RESTRICT="!test? ( test )"

RDEPEND="virtual/perl-Carp"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Exporter
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-Test
		virtual/perl-Test-Simple
	)
"
