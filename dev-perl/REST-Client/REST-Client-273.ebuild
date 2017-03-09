# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KKANE
inherit perl-module

DESCRIPTION="A simple client for interacting with RESTful http/https resources"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-perl/LWP-Protocol-https
	dev-perl/libwww-perl
	dev-perl/URI
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
