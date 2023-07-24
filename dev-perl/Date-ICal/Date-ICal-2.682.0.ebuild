# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SKIM
DIST_VERSION=2.682
inherit perl-module

DESCRIPTION="ICal format date base module for Perl"

SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 x86"

RDEPEND="
	>=dev-perl/Date-Leapyear-1.30.0
	virtual/perl-Storable
	virtual/perl-Time-HiRes
	virtual/perl-Time-Local
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Harness-2.250.0
		>=virtual/perl-Test-Simple-0.450.0
	)
"
