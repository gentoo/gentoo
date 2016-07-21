# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MIYAGAWA
MODULE_VERSION=0.15
inherit perl-module

DESCRIPTION="Adapt CGI.pm to the PSGI protocol"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/CGI-3.330.0
"
DEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.88
	)
"

SRC_TEST="do"
