# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MANWAR
DIST_VERSION=2.21
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Provide a progress meter on a standard terminal"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Class-MethodMaker-1.20.0
	>=dev-perl/TermReadKey-2.140.0
	virtual/perl-autodie
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-Exception-0.310.0
		>=dev-perl/Capture-Tiny-0.130.0
		>=virtual/perl-Test-Simple-0.800.0
	)
"
