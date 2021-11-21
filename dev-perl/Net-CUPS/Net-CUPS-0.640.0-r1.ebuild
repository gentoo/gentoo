# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NINE
DIST_VERSION=0.64
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="CUPS C API Interface"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	net-print/cups
	net-print/cups-filters
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
DEPEND="${RDEPEND}
"
