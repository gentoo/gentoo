# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MIYAGAWA
MODULE_VERSION=0.21
inherit perl-module

DESCRIPTION="PSGI adapter for CGI"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/CGI-3.630.0
	dev-perl/HTTP-Message
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		>=dev-perl/Test-Requires-0.80.0
	)
"

SRC_TEST="do parallel"
