# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ABH
MODULE_VERSION=0.52
inherit perl-module

DESCRIPTION="PSGI handler for HTML::Mason"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/CGI-PSGI
	dev-perl/HTML-Mason
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.310.0
	test? (
		dev-perl/Plack
	)
"

SRC_TEST=do
