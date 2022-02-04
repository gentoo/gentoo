# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RBOW
DIST_VERSION=1.72
inherit perl-module

DESCRIPTION="Simple Perl module that tracks Gregorian leap years"

SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
