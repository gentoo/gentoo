# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOBYINK
DIST_VERSION=0.100
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Easily translate Moose code to Moo"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc"

RDEPEND="
	>=dev-perl/Moo-2.0.0
	>=dev-perl/Sub-HandlesVia-0.13.0
	>=dev-perl/Type-Tiny-1.0.1
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		>=dev-perl/Test-Fatal-0.10.0
		>=virtual/perl-Test-Simple-0.960.0
		>=dev-perl/Test-Requires-0.60.0
	)
"
