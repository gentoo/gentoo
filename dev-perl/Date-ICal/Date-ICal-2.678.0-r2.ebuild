# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RBOW
DIST_VERSION=2.678
inherit perl-module

DESCRIPTION="ICal format date base module for Perl"

SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Date-Leapyear-1.30.0
	virtual/perl-Storable
	virtual/perl-Time-HiRes
	virtual/perl-Time-Local
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Harness-2.250.0
		>=virtual/perl-Test-Simple-0.450.0
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.678-timegm-year.patch"
)
