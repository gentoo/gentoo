# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ILMARI
MODULE_VERSION=0.11021
inherit perl-module

DESCRIPTION="Manipulate structured data definitions (SQL and more)"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix ~x86-solaris"
IUSE="test"

RDEPEND="
	dev-perl/Carp-Clan
	>=dev-perl/DBI-1.540.0
	virtual/perl-Digest-SHA
	>=dev-perl/File-ShareDir-1.0.0
	>=dev-perl/List-MoreUtils-0.90.0
	>=dev-perl/Moo-1.0.3
	>=dev-perl/Package-Variant-1.1.1
	>=dev-perl/Parse-RecDescent-1.967.9
	>=dev-perl/Try-Tiny-0.40.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=dev-perl/JSON-2
	>=dev-perl/XML-Writer-0.500.0
	>=dev-perl/YAML-0.660.0
	test? (
		dev-perl/HTML-Parser
		dev-perl/Spreadsheet-ParseExcel
		>=dev-perl/Template-Toolkit-2.200.0
		dev-perl/Test-Exception
		dev-perl/Test-Differences
		>=dev-perl/XML-LibXML-1.690.0
	)
"

SRC_TEST=do
