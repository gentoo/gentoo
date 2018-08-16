# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NINE
DIST_VERSION=0.64
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="CUPS C API Interface"

SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="test"

RDEPEND="
	net-print/cups
	net-print/cups-filters
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
