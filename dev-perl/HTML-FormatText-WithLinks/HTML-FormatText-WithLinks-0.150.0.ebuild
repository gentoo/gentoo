# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=STRUAN
MODULE_VERSION=0.15
inherit perl-module

DESCRIPTION="HTML to text conversion with links as footnotes"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	>=dev-perl/HTML-Format-2
	dev-perl/HTML-Tree
	dev-perl/URI
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
