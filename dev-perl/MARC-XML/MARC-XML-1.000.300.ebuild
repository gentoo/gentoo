# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MARC-XML/MARC-XML-1.000.300.ebuild,v 1.1 2014/01/23 17:15:46 zlogene Exp $

EAPI=5

MODULE_AUTHOR=GMCHARLT
MODULE_VERSION=1.0.3
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
