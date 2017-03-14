# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=RUZ
MODULE_VERSION=0.53
inherit perl-module

DESCRIPTION="PSGI handler for HTML::Mason"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/CGI-PSGI
	dev-perl/HTML-Mason
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		dev-perl/Plack
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do parallel"
