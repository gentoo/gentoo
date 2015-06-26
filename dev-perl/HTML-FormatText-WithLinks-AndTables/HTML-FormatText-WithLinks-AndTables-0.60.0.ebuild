# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-FormatText-WithLinks-AndTables/HTML-FormatText-WithLinks-AndTables-0.60.0.ebuild,v 1.1 2015/06/26 21:33:35 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DALEEVANS
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Converts HTML to text with tables intact"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-perl/HTML-Format
	dev-perl/HTML-FormatText-WithLinks
	dev-perl/HTML-Tree
"
RDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
