# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MANWAR
DIST_VERSION=2.23
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Provide a progress meter on a standard terminal"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv ~sparc x86 ~x86-linux"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Class-MethodMaker-1.20.0
	>=dev-perl/TermReadKey-2.140.0
	virtual/perl-autodie
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-Exception-0.310.0
		>=dev-perl/Capture-Tiny-0.130.0
		>=virtual/perl-Test-Simple-0.800.0
		dev-perl/Test-Warnings
	)
"
