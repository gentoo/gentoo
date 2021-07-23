# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CJM
DIST_VERSION=1.400
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Parse Palm database files"

SLOT="0"
KEYWORDS="amd64 ppc x86"

# This package is split upstream from "Palm"
# so collides before 1.14.0
RDEPEND="
	!<dev-perl/Palm-1.14.0
"

BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
