# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MARKOV
DIST_VERSION=3.20
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Soap 1.1 XML Compiler"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/File-Slurp-Tiny
	>=dev-perl/libwww-perl-6.80.0
	>=dev-perl/Log-Report-1.50.0
	virtual/perl-Time-HiRes
	>=dev-perl/XML-Compile-1.510.0
	>=dev-perl/XML-Compile-Cache-1.30.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.540.0
		>=dev-perl/XML-Compile-Tester-0.900.0
	)
"
