# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OLEG
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="LWP::UserAgent with simple caching mechanism"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-perl/libwww-perl
"
BDEPEND="${RDEPEND}
	virtual/perl-File-Temp
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
	test? (
		>=dev-perl/Test-Mock-LWP-Dispatch-0.20.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"
