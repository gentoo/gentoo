# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RIXED
DIST_VERSION=1.21
inherit perl-module

DESCRIPTION="Parse iCalendar files into a data structure"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-perl/DateTime-Format-ICal-0.80.0
	dev-perl/IO-String
	>=dev-perl/Text-vFile-asData-0.20.0
	>=virtual/perl-IO-1.100.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/DateTime
		>=dev-perl/FreezeThaw-0.430.0
	)
"
