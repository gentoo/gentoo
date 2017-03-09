# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=GMCHARLT
inherit perl-module

DESCRIPTION="A subclass of MARC.pm to provide XML support"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-perl/XML-SAX
	dev-perl/XML-LibXML
	dev-perl/MARC-Charset
	dev-perl/MARC-Record"
DEPEND="${RDEPEND}"

SRC_TEST=do
