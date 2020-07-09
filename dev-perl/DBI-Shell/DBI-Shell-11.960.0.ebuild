# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DLAMBLEY
DIST_VERSION=11.96
inherit perl-module

DESCRIPTION="Interactive command shell for the DBI"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
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

PATCHES=(
	"${FILESDIR}/${PN}-11.96-sprintf-warn.patch"
)
