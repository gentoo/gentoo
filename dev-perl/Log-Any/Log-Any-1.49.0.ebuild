# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PREACTION
DIST_VERSION=1.049
inherit perl-module

DESCRIPTION="Bringing loggers and listeners together"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="test minimal"

# Test::Builder needed for Log/Any/Adapter/Test.pm
# constant -> perl
RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Exporter
	virtual/perl-IO
	virtual/perl-Sys-Syslog
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? ( >=virtual/perl-CPAN-Meta-2.120.900 )
		virtual/perl-File-Spec
	)
"
