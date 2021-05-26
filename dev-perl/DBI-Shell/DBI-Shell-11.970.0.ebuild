# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DLAMBLEY
DIST_VERSION=11.97
inherit perl-module

DESCRIPTION="Interactive command shell for the DBI"

SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="minimal test"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? (
		virtual/perl-IO
		dev-perl/TermReadKey
		virtual/perl-Text-ParseWords
		virtual/perl-Text-Tabs+Wrap
	)
	virtual/perl-Carp
	dev-perl/DBI
	virtual/perl-Data-Dumper
	virtual/perl-Exporter
	>=dev-perl/File-HomeDir-0.500.0
	virtual/perl-File-Spec
	dev-perl/IO-Interactive
	dev-perl/IO-Tee
	virtual/perl-Term-ReadLine
	dev-perl/Text-CSV_XS
	dev-perl/Text-Reform
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Getopt-Long-2.170.0
		virtual/perl-Test-Simple
	)
"
