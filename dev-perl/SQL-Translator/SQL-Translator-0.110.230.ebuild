# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ILMARI
DIST_VERSION=0.11023
inherit perl-module

DESCRIPTION="Manipulate structured data definitions (SQL and more)"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~ppc-aix ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Carp-Clan
	>=dev-perl/DBI-1.540.0
	virtual/perl-Digest-SHA
	>=dev-perl/File-ShareDir-1.0.0
	>=dev-perl/Moo-1.0.3
	>=dev-perl/Package-Variant-1.1.1
	>=dev-perl/Parse-RecDescent-1.967.9
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Quote
	>=dev-perl/Try-Tiny-0.40.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=dev-perl/JSON-2
	>=dev-perl/XML-Writer-0.500.0
	>=dev-perl/YAML-0.660.0
	test? (
		dev-perl/HTML-Parser
		>=dev-perl/Spreadsheet-ParseExcel-0.410.0
		>=dev-perl/Template-Toolkit-2.200.0
		dev-perl/Test-Exception
		>=dev-perl/Test-Differences-0.310.0
		>=virtual/perl-Test-Simple-0.880.0
		>=dev-perl/XML-LibXML-1.690.0
	)
"
