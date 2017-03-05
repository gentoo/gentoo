# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NEILB
DIST_VERSION=0.13
inherit perl-module

DESCRIPTION="Smart URI fetching/caching"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-ErrorHandler
	dev-perl/libwww-perl
	virtual/perl-Storable
	dev-perl/URI
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-Test-Simple
		>=dev-perl/Test-RequiresInternet-0.50.0
	)
"
