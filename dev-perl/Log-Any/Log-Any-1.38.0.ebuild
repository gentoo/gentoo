# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=1.038
inherit perl-module

DESCRIPTION="Bringing loggers and listeners together"

SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE="test minimal"

# Test::Builder needed for Log/Any/Adapter/Test.pm
# constant -> perl
RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Exporter
	virtual/perl-IO
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		!minimal? ( >=virtual/perl-CPAN-Meta-2.120.900 )
		virtual/perl-File-Spec
		virtual/perl-File-Temp
	)
"
