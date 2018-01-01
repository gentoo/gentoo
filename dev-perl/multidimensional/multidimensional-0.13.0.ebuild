# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ILMARI
DIST_VERSION=0.013
inherit perl-module

DESCRIPTION="disables multidimensional array emulation"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE="test"

RDEPEND="
	>=dev-perl/B-Hooks-OP-Check-0.190.0
	>=dev-perl/Lexical-SealRequireHints-0.5.0
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/ExtUtils-Depends
	test? (
		>=virtual/perl-CPAN-Meta-2.112.580
		>=virtual/perl-Test-Simple-0.880.0
	)
"
