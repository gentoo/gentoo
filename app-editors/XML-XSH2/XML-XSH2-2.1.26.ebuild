# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHOROBA
inherit perl-module

DESCRIPTION="Powerful scripting language/shell for XPath-based editing of XML"
HOMEPAGE="http://xsh.sourceforge.net/"

LICENSE="|| ( Artistic GPL-2 )" # Artistic or GPL-2
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/IO-stringy
	>=dev-perl/Parse-RecDescent-1.940.0
	virtual/perl-Term-ReadLine
	dev-perl/Term-ReadLine-Perl
	dev-perl/URI
	>=dev-perl/XML-Filter-DOMFilter-LibXML-0.30.0
	>=dev-perl/XML-LibXML-1.600.0
	dev-perl/XML-LibXML-Iterator
	>=dev-perl/XML-LibXSLT-1.600.0
	>=dev-perl/XML-SAX-Writer-0.440.0
	>=dev-perl/XML-XUpdate-LibXML-0.6.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
