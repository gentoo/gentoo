# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_PN=BioPerl
MODULE_AUTHOR=CJFIELDS
MODULE_VERSION=1.6.901
inherit perl-module

SUBPROJECTS="+db +network +run"
MIN_PV=$PV

DESCRIPTION="Perl tools for bioinformatics - Core modules"
HOMEPAGE="http://www.bioperl.org/"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-minimal graphviz sqlite ${SUBPROJECTS}"

REQUIRED_USE="minimal? ( !graphviz )"

CDEPEND="
	dev-perl/libwww-perl
	!minimal? (
		dev-perl/Algorithm-Munkres
		dev-perl/Array-Compare
		dev-perl/yaml
		dev-perl/Bio-ASN1-EntrezGene
		dev-perl/Clone
		dev-perl/Convert-Binary-C
		dev-perl/Data-Stag
		dev-perl/GD
		dev-perl/Graph
		>=dev-perl/HTML-Parser-3.60
		dev-perl/List-MoreUtils
		dev-perl/Math-Random
		dev-perl/PostScript
		dev-perl/Set-Scalar
		dev-perl/SOAP-Lite
		dev-perl/Sort-Naturally
		dev-perl/Spreadsheet-ParseExcel
		>=virtual/perl-Storable-2.05
		>=dev-perl/SVG-2.26
		>=dev-perl/SVG-Graph-0.01
		dev-perl/URI
		>=dev-perl/XML-DOM-XPath-0.13
		dev-perl/XML-Parser
		>=dev-perl/XML-SAX-0.15
		dev-perl/XML-Simple
		dev-perl/XML-Twig
		>=dev-perl/XML-Writer-0.4
		dev-perl/XML-DOM
		dev-perl/XML-XPath
	)
	graphviz? ( dev-perl/GraphViz )
	sqlite? ( dev-perl/DBD-SQLite )"
DEPEND="dev-perl/Module-Build
	${CDEPEND}"
RDEPEND="${CDEPEND}"
PDEPEND="db? ( >=sci-biology/bioperl-db-${MIN_PV} )
	network? ( >=sci-biology/bioperl-network-${MIN_PV} )
	run? ( >=sci-biology/bioperl-run-${MIN_PV} )"

src_install() {
	mydoc="AUTHORS BUGS FAQ"
	perl-module_src_install
}
