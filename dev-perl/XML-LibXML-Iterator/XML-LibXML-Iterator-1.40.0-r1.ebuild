# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PHISH
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="Iterator class for XML::LibXML parsed documents"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc sparc x86"
IUSE=""

DEPEND="dev-perl/XML-LibXML
	dev-perl/XML-NodeFilter"
RDEPEND="${DEPEND}"

SRC_TEST="do"
