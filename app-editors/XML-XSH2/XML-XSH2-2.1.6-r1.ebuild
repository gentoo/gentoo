# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PAJAS
MODULE_VERSION=2.1.6
inherit perl-module

DESCRIPTION="XML Editing Shell"
HOMEPAGE="http://xsh.sourceforge.net/"

LICENSE="|| ( Artistic GPL-2 )" # Artistic or GPL-2
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=dev-perl/XML-LibXML-1.61
	>=dev-perl/Parse-RecDescent-1.94
	>=dev-perl/XML-LibXSLT-1.53
	dev-perl/IO-stringy
	dev-perl/XML-SAX-Writer
	dev-perl/Term-ReadLine-Perl
	dev-perl/URI
	dev-perl/XML-Filter-DOMFilter-LibXML
	>=dev-perl/XML-XUpdate-LibXML-0.4.0
"
DEPEND="${RDEPEND}"

SRC_TEST=do
