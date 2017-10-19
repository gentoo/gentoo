# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=1.003028
inherit perl-module

DESCRIPTION="A modern perl interactive shell"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"

RDEPEND="
	dev-perl/File-HomeDir
	virtual/perl-File-Spec
	>=virtual/perl-JSON-PP-2.273.0
	dev-perl/Module-Runtime
	>=dev-perl/Moose-0.930.0
	>=dev-perl/MooseX-Getopt-0.180.0
	>=dev-perl/MooseX-Object-Pluggable-0.0.9
	virtual/perl-Scalar-List-Utils
	dev-perl/Task-Weaken
	virtual/perl-Term-ANSIColor
	virtual/perl-Time-HiRes
	dev-perl/namespace-autoclean
	dev-perl/App-Nopaste
	dev-perl/B-Keywords
	>=dev-perl/Data-Dump-Streamer-2.390.0
	dev-perl/Data-Dumper-Concise
	dev-perl/File-Next
	dev-perl/Lexical-Persistence
	dev-perl/Module-Refresh
	dev-perl/PPI
	dev-perl/Sys-SigAction
"
# B::Concise? => perl
# Devel::Peek => perl
# Term::ReadLine => perl

DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=virtual/perl-CPAN-Meta-Requirements-2.120.620
	virtual/perl-Module-Metadata
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
		virtual/perl-if
	)
"
