# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-FormatText-WithLinks-AndTables/HTML-FormatText-WithLinks-AndTables-0.20.0.ebuild,v 1.1 2014/05/28 12:12:21 zlogene Exp $

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
