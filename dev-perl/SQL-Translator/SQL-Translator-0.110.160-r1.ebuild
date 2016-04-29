# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=FREW
MODULE_VERSION=${PV:2:6}
MODULE_VERSION=${PV:0:1}.${MODULE_VERSION/.}
inherit perl-module

DESCRIPTION="Convert RDBMS SQL CREATE syntax"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix ~x86-solaris"
IUSE="test"

RDEPEND="
	dev-perl/Carp-Clan
	>=dev-perl/YAML-0.680.0
	>=dev-perl/IO-stringy-2.110.0
	>=dev-perl/Parse-RecDescent-1.967.9
	>=dev-perl/File-ShareDir-1.0.0
	dev-perl/List-MoreUtils
	dev-perl/DBI
	>=dev-perl/Try-Tiny-0.40.0
	>=dev-perl/Moo-1.0.3
	>=dev-perl/Package-Variant-1.1.1
	>=dev-perl/XML-Writer-0.500.0
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/HTML-Parser
		dev-perl/Spreadsheet-ParseExcel
		>=dev-perl/Template-Toolkit-2.200.0
		dev-perl/Test-Exception
		dev-perl/Test-Differences
		dev-perl/Test-Pod
		>=dev-perl/XML-LibXML-1.690.0
	)
"

SRC_TEST=do
