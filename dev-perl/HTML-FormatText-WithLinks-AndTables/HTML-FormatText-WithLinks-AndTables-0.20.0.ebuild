# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SFRYER
MODULE_VERSION=0.02
inherit perl-module

DESCRIPTION="Converts HTML to text with tables intact"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/HTML-FormatText-WithLinks
	dev-perl/HTML-Tree
	test? ( virtual/perl-Test-Simple )
"

S="${WORKDIR}/${PN}"

SRC_TEST="do"
