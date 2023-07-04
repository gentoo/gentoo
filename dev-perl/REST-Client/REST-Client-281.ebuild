# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AKHUETTEL
inherit perl-module

DESCRIPTION="A simple client for interacting with RESTful http/https resources"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/LWP-Protocol-https
	dev-perl/libwww-perl
	dev-perl/URI
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/HTTP-Server-Simple
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
	)
"
