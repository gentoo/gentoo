# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MCNEWTON
DIST_VERSION=0.09
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Allows you to have a simple method of writing PostScript files from Perl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ppc sparc x86"

RDEPEND=""
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.180.0 )
"
